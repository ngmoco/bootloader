# encoding: utf-8

require 'configurability/config'
require 'active_support'
require 'syslog-logger'
require 'logger'

module Bootloader
  module_function

  EXCLUDED_CONFIGS = %w'newrelic'

  # Returns the current environment.
  #
  # Parses $RACK_ENV, $RAILS_ENV and $RUBY_ENV in that order.
  # Defauts to 'development' if none is defined.
  #
  # @return [String]  Current environment.
  def env
    @@env ||= [ENV['RACK_ENV'], ENV['RAILS_ENV'], ENV['RUBY_ENV'], 'development'].compact.first
  end

  # Returns the project's root path.
  #
  # @return [String]  Project root path
  def root_path
    @@root ||= File.dirname(Bundler.default_gemfile.to_path)
  end

  # Loads a YAML config for the current environment.
  #
  # Config files must:
  #   * Be located under $ROOT/config
  #   * Have the .yml extension
  #
  # @example
  #   Bootloader.load_config 'foo' # => Creates FooConfig for $ROOT/config/foo.yml
  #
  # @param  [String] filename  config name without the '.yml' extension
  #
  # @return [Configurability::Config::Struct]
  def load_config(filename)
    YAML::ENGINE.yamler = 'psych' # See http://darwinweb.net/articles/convert-syck-to-psych-yaml-format for some background
    Configurability::Config.load(File.join(root_path, 'config', "#{filename}.yml"))[Bootloader.env.to_sym]
  end

  # Loads all the YAML configs that are available for the current environment.
  # Each config gets assigned its top-level constant. E.g. FooConfig for 'foo.yml'.
  #
  # @example
  #
  #   $ROOT/
  #     config/
  #       foo.yml
  #       foo_bar.yml
  #
  #   Bootloader.load_configs # => Creates both 'FooConfig' and 'FooBarConfig'
  def load_configs
    Dir.glob(File.join(root_path, 'config', '*.yml')).each do |config|
      filename = File.basename(config, '.yml')
      next if EXCLUDED_CONFIGS.include?(filename)
      module_name = "#{::ActiveSupport::Inflector.camelize(filename)}Config"
      unless Object.const_defined?(module_name)
        config = Bootloader.load_config(filename)
        unless config.to_a.empty?
          Object.const_set(module_name, config)
          puts "Loaded #{module_name} from config/#{filename}.yml"
        end
      end
    end
  end

  # Load boot.rb files.
  #
  # @example
  #  $ROOT/
  #    foo/
  #      boot.rb
  #      foo.rb
  #      bar.rb
  #
  #   Bootloader.load 'foo' # => Loads $PROJECT/foo/boot.rb
  #
  # @param [String] dir
  def load(dir)
    require File.join(root_path, dir, 'boot.rb')
  end

  # Loads a YAML config.
  #
  # @return [Configurability::Config::Struct]
  def load_yml(path)
    Configurability::Config.load(path)
  end

  # Load all the files under the given paths.
  def load_dir(*paths)
    Dir.glob(File.join(root_path, *paths, '*.rb')).each { |f| require f }
  end

  def development?
    %w(development test).include?(env)
  end

  def logger(name, level = 'debug', output = :syslog)
    if development? || output != :syslog
      STDOUT.sync = true
      Logger.new(STDOUT).tap do |logger|
        logger.formatter = proc do |level, time, _, message|
          "[#{time.strftime("%Y-%m-%d %H:%M:%S")}] [#{level.rjust(5)}] #{message}\n"
        end
      end
    else
      Logger::Syslog.new(name).tap do |logger|
        logger.formatter = Logger::SyslogFormatter.new
        logger.level = eval("Logger::#{level.upcase}")
      end
    end
  end

  def load_mongoid
    mongoid_config_path = "#{root_path}/config/mongoid.yml"
    if File.exists?(mongoid_config_path)
      Mongoid.load!(mongoid_config_path, env)
      puts "Loaded mongoid config"
    end
  end

end
