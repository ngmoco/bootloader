# encoding: utf-8

require 'configurability/config'
require 'active_support'
require 'syslog-logger'

module Bootloader
  module_function

  # @param opts [Hash]
  # @opts opts :environment
  def setup(opts = {})
    unless @setup
      set_env
      load_configs
      connect_to_mongodb if opts.fetch(:mongodb, true)
      load_dir('models')
      load_dir('lib')
      @setup = false
    end
  end

  # If not already defined set the RACK_ENV top-level constant
  # to $RACK_ENV, $RAILS_ENV or 'development' (in that order)
  #
  def set_env
    unless Object.const_defined?(:RACK_ENV)
      env = [ENV['RACK_ENV'], ENV['RAILS_ENV'], 'development'].compact.first
      Object.const_set(:RACK_ENV, env)
    end
    puts "Running in #{RACK_ENV} mode"
    RACK_ENV
  end

  def env
    RACK_ENV
  end

  def connect_to_mongodb
    Mongoid.load!(File.join(root_path, 'config', 'mongoid.yml'))
  end

  def root_path
    @root ||= File.dirname(Bundler.default_gemfile.to_path)
  end

  def load_dir(*paths)
    Dir.glob(File.join(root_path, *paths, '*.rb')).each { |f| require f }
  end

  # Load the component's boot.rb file.
  # The component folder must be directly located under ROOT.
  #
  # @example
  #   ROOT/foo/boot.rb
  #   Bootloader.load(:foo)
  #   Bootloader.load('foo')
  #
  # @param component [Symbol|String]
  def load(component)
    require File.join(root_path, component.to_s, 'boot.rb')
  end

  # Load a YML config file.
  # Config files must be located under ROOT/config and have the '.yml' extension.
  #
  # @example
  #   ROOT/config/foo.yml
  #   Bootloader.load_config(:foo), or
  #   Bootloader.load_config('foo')
  #
  # @param filename [Symbol|String] Filename without the '.yml' extension
  # @return
  def load_config(filename, opts = {})
    YAML::ENGINE.yamler = 'syck'
    Configurability::Config.load(File.join(root_path, 'config', "#{filename}.yml"))[Bootloader.env.to_sym]
  end

  def load_yml(path)
    Configurability::Config.load(path)
  end

  # Set namespaced constants for the yml configs
  #
  # foo.yml #=> FooConfig
  # foo_bar.yml #=> FooBarConfig
  def load_configs(opts = {})
    Dir.glob(File.join(root_path, 'config', '*.yml')).each do |config|
      filename = File.basename(config, '.yml')
      next if filename == 'mongoid'
      module_name = "#{::ActiveSupport::Inflector.camelize(filename)}Config"
      const = Object.const_set(module_name, Bootloader.load_config(filename))
      puts "Loaded #{module_name} from config/#{filename}.yml"
    end
  end

  def development?
    %w(development test).include?(env)
  end

  def logger(name, level = 'debug')
    Logger::Syslog.new(name).tap do |logger|
      logger.formatter = Logger::SyslogFormatter.new
      logger.level = eval("Logger::#{level.upcase}")
    end
  end

end
