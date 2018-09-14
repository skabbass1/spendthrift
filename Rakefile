require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :package, [:name] do |t, args| 
  FileUtils.rm_rf('ruby-env') if Dir.exists?('ruby-env')
  Dir.mkdir('ruby-env')
  FileUtils.cp_r ENV['GEM_HOME'] ,'ruby-env/' 
  FileUtils.cp_r ENV['MY_RUBY_HOME'] ,'ruby-env/' 
  
  File.open('bin/run.sh', 'w', perm: 0755) do |f|
   f.puts '#!/bin/sh'
   f.puts 'DIR=`dirname "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"`' 
   f.puts "export GEM_HOME=${DIR}/ruby-env/#{ENV['RUBY_VERSION']}@#{args[:name]}"   
   f.puts "export GEM_PATH=${DIR}/ruby-env/#{ENV['RUBY_VERSION']}@#{args[:name]}"   
   f.puts "export MY_RUBY_HOME=${DIR}/ruby-env/#{ENV['RUBY_VERSION']}" 
   f.puts "export PATH=${DIR}/ruby-env/#{ENV['RUBY_VERSION']}@#{args[:name]}/bin:${DIR}/ruby-env/#{ENV['RUBY_VERSION']}/bin:$PATH"
   f.puts
   f.puts "exec ruby bin/#{args[:name]} $@" 
  end
end
