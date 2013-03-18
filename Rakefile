# encoding: utf-8

desc 'Open an IRB console preloaded with the bootloader gem'
task :console do
  require 'bundler/setup'
  Bundler.require
  require 'irb'
  require 'irb/completion'
  ARGV.clear
  IRB.start
end

task :c => :console
