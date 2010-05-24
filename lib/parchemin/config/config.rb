# coding: utf-8

module Parchemin
  
  # This class holds all the configuration variables of the application
  module Config
    
    # sets the blog'a author name
    def self.author_name=(name)
      @author_name = name
    end
    
    # returns the blog's author name
    def self.author_name
      raise "The author_name configuration variable has not been set" if @author_name.nil?
      @author_name
    end
    
    # sets the name of the blog
    def self.blog_name=(name)
      @blog_name = name
    end
    
    # return the name of the blog
    def self.blog_name
      raise "The blog_name configuration variable has not been set" if @blog_name.nil?
      @blog_name
    end
    
    # sets the host of the application. This variable is useful for define the RSS feed
    def self.host=(host)
      @host = host
    end
    
    # returns the host of the application
    def self.host
      raise "The host configuration variable has not been set" if @host.nil?
      @host
    end
    
    # sets the application's root directory
    def self.root_path=(path)
      @root_path = path
    end
    
    # returns the application's root directory
    def self.root_path
      raise "The root_path configuration variable has not been set" if @root_path.nil?
      @root_path
    end
    
    # sets the directory where to find the articles. By defaut it is sets to ROOT_PATH/articles
    def self.articles_path=(path)
      @articles_path = path
    end
    
    # return the directory where to find the articles
    def self.articles_path
      @articles_path ||= "#{root_path}/articles"
    end
    
    # sets the directory where to find the static content such as about page. By defaut it is sets to ROOT_PATH/statics
    def self.statics_path=(path)
      @statics_path = path
    end
    
    # returns the directory where to find the static content such as about page.
    def self.statics_path
      @statics_path ||= "#{root_path}/statics"
    end
       
    # sets the name of the MongoDB database where the comments are stored
    def self.db_name=(name)
      Mongoid.configure do |config|
        config.allow_dynamic_fields = false
        config.master = Mongo::Connection.new.db(name)
      end
    end
  end
end
