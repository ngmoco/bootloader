#! /usr/bin/env gem build
# encoding: utf-8

require 'base64'

Gem::Specification.new do |s|
  s.name = 'bootloader'
  s.version = '0.1'
  s.authors = ['Christian Hoareau']
  s.email = ["Y2hvYXJlYXVAbmdtb2NvLmNvbQ==\n"].map { |i| Base64.decode64(i) }
  s.homepage = 'http://github.ngmoco.com/choareau/bootloader'
  s.summary = 'A bootloader API for your awesome, multi-component Ruby project'
  s.description = s.summary

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
  s.add_development_dependency 'yard'

end
