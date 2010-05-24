$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'parchemin'
require 'rspec/core'
require 'rspec/autorun'
require 'rack/test'
require 'nokogiri'

module Parchemin
  class Application
    set :environment, :test
    set :run, false
    set :raise_errors, true
    set :logging, false
  end
end

Parchemin::Config.blog_name = "Parchemin Test"
Parchemin::Config.author_name = "Rawane ZOSSOU"
Parchemin::Config.host = "http://example.com"
Parchemin::Config.project_path = File.join(File.dirname(__FILE__), 'bin')
Parchemin::Config.db_name = 'parchemin_test'
