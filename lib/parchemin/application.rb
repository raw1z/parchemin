# coding: utf-8

require File.join(File.dirname(__FILE__), "config/config")

module Parchemin
  class Application < Sinatra::Base
    
    set :public, File.expand_path(File.join(File.dirname(__FILE__), "../../app/public"))
    set :views, File.expand_path(File.join(File.dirname(__FILE__), "../../app/views"))
    
    require File.join(File.dirname(__FILE__), "config/environment")
    
    before do
      @blog_name = Parchemin::Config.blog_name
      @author_name = Parchemin::Config.author_name
      @abstract = Parchemin::Static.new('abstract')
    end
    
    get '/:name.css' do
      content_type 'text/css', :charset => 'utf-8'
      sass(:"#{params[:name]}", Compass.sass_engine_options )
    end

    get '/' do
      @articles = Parchemin::Article.all
      haml :index
    end

    get '/articles/:article' do |filename|
      @article = Parchemin::Article.new("#{Parchemin::Config.articles_path}/#{filename}.markdown")
      @comments = @article.comments
      @comment = Parchemin::Comment.new
      haml :show
    end

    get '/tags/:tag' do |tag|
      @tag = tag
      @articles = Parchemin::Article.all(:tag => tag)
      haml :index
    end

    get '/search' do
      @search = params[:search]
      @articles = Parchemin::Article.search(params[:search])
      haml :index
    end

    get '/statics/:static' do |static|
      @static = Parchemin::Static.new(params[:static])
      haml :static
    end

    post '/comment' do
      @article = Parchemin::Article.new("#{params[:comment][:article]}.markdown")
      @comments = @article.comments

      @comment = Parchemin::Comment.new(params[:comment])
      if @comment.save
        flash[:notice] = "Commentaire ajouté avec succès. Merci."
        redirect "/articles/#{@article.id}"
      else
        flash[:error] = "Données non valides. Verifiez le formulaire svp."
        haml :show
      end
    end

    get '/rss' do
      @host = Parchemin::Config.host
      @articles = Parchemin::Article.all
      builder :rss
    end
  end
end