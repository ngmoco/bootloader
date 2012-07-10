# encoding: utf-8

desc 'Open an irb session preloaded with the gem library'
task :console do
    sh 'irb -rubygems -I . -r boot.rb'
end

task :c => :console
