require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "parchemin"
    gem.summary = "File-based blog engine"
    gem.description = "Parchemin allows you to create and manage a blog whose contents are not stored in a database but directly in files"
    gem.email = "dev@raw1z.fr"
    gem.homepage = "http://github.com/raw1z/parchemin"
    gem.authors = ["Rawane ZOSSOU"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "rack-test", ">= 0.5.3"
    gem.add_development_dependency "nokogiri", ">= 1.4.2"
    gem.add_dependency 'sinatra', '>= 1.0'
    gem.add_dependency 'haml', '>= 3.0.4'
    gem.add_dependency 'compass', '>= 0.10.1'
    gem.add_dependency 'compass-susy-plugin', '>= 0.7.0.pre8'
    gem.add_dependency 'rdiscount', '>= 1.6.3'
    gem.files =  FileList["[A-Z]*", "{lib}/**/*", "{bin}/**/*", "{app}/**/*"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core'
require 'rspec/core/rake_task'
Rspec::Core::RakeTask.new(:spec) do |spec|
end

Rspec::Core::RakeTask.new(:rcov) do |spec|
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "parchemin #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
