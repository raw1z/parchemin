require 'haml'
require 'fileutils'

module Parchemin
  
  # This class contains useful tools.
  class Utils
    
    # Creates a directory.
    def self.mkdir(name)
      FileUtils.mkdir_p(name)
    end
    
    # Copies an entire directory into another.
    def self.cpdir(src, dest)
      new_dir = "#{dest}/#{File.basename(src)}"
      mkdir(new_dir)
      
      Dir.foreach(src) do |file|
        next if %w(. ..).include? file
        filename = "#{src}/#{file}"
        
        if File.directory?(filename)
          cpdir(filename, new_dir)
        else
          FileUtils.copy filename, new_dir
        end
      end
    end
    
    # Renders an HAML template.
    def self.render(template, locals = {})
      haml_engine = Haml::Engine.new(template)
      haml_engine.render(Object.new, locals)
    end
    
  end
end