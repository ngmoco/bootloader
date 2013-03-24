#! /usr/bin/env gem build
# encoding: utf-8

require File.expand_path '../lib/version', __FILE__

Gem::Specification.new do |s|
  s.name        = 'bootloader'
  s.version     = Bootloader::VERSION
  s.summary     = 'Bootload your Ruby application with ease.'
  s.description = 'bootloader takes care of many of the common tasks across your Ruby applications.'

  s.license  = 'MIT'

  s.authors  = 'Christian Hoareau'
  s.email    = 'christian.hoareau@dena.com'

  ignores = File.readlines('.gitignore').grep(/\S+/).map { |l| l.chomp }
  dotfiles = ['.gitignore', '.rspec']

  s.files = Dir['**/*'].reject { |f| File.directory?(f) || ignores.any? {|i| File.fnmatch(i, f) } } + dotfiles
  s.test_files = s.files.grep(/^spec\//)
  s.require_paths = ['lib']

  s.add_dependency 'bundler'
  s.add_dependency 'configurability'
  s.add_dependency 'activesupport'
  s.add_dependency 'syslog-logger', '~> 1.6.8'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
end
