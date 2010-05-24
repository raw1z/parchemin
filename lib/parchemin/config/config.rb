# coding: utf-8

module Parchemin
  module Config
    
    def self.author_name=(name)
      @author_name = name
    end
    
    def self.author_name
      raise "The author_name configuration variable has not been set" if @author_name.nil?
      @author_name
    end
    
    def self.blog_name=(name)
      @blog_name = name
    end
    
    def self.blog_name
      raise "The blog_name configuration variable has not been set" if @blog_name.nil?
      @blog_name
    end
    
    def self.host=(host)
      @host = host
    end
    
    def self.host
      raise "The host configuration variable has not been set" if @host.nil?
      @host
    end
    
    def self.project_path=(path)
      @project_path = path
    end
    
    def self.project_path
      raise "The project_path configuration variable has not been set" if @project_path.nil?
      @project_path
    end
    
    def self.articles_path=(path)
      @articles_path = path
    end
    
    def self.articles_path
      @articles_path ||= "#{project_path}/articles"
    end
    
    def self.statics_path=(path)
      @statics_path = path
    end
    
    def self.statics_path
      @statics_path ||= "#{project_path}/statics"
    end
       
    def self.db_name=(name)
      Mongoid.configure do |config|
        config.allow_dynamic_fields = false
        config.master = Mongo::Connection.new.db(name)
      end
    end
  end
end
