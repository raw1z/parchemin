require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Parchemin" do
  include Rack::Test::Methods
  
  def app
    @app ||= Parchemin::Application
  end
  
  before :all do
    Parchemin::Comment.delete_all
  end
  
  it "renders the stylesheet" do
    get '/layout.css'
    last_response.should be_ok
  end
  
  it "renders the home page" do
    get '/'
    
    doc = Nokogiri::HTML(last_response.body)
    doc.css('.abstract').count.should == 4
    doc.css('.details').count.should == 4
    
    last_response.should be_ok
  end
  
  it "renders an article" do
    article = Parchemin::Article.new('lorem')
    Parchemin::Comment.create(:article => article.id, :author => 'Rawane', :body => 'test')
    Parchemin::Comment.create(:article => article.id, :author => 'Rawane', :body => 'test')
    Parchemin::Comment.create(:article => article.id, :author => 'Rawane', :body => 'test')
    
    get 'articles/lorem'
    
    doc = Nokogiri::HTML(last_response.body)
    doc.css('.comment').count.should == 3
    doc.css('.add').count.should == 1
    
    last_response.should be_ok
  end
  
  it "filters articles by tag" do
    get '/tags/tutorial'
    
    doc = Nokogiri::HTML(last_response.body)
    doc.css('.abstract').count.should == 2
    
    last_response.should be_ok
  end
  
  it "performs accurate searches" do
    get '/search', {:search => 'lorem ipsum'}
    
    doc = Nokogiri::HTML(last_response.body)
    doc.css('.abstract').count.should == 2
    
    last_response.should be_ok
  end
  
  it "creates articles comments with valid attributes" do
    article = Parchemin::Article.new('azerty')
    
    post '/comment', {:comment => {:article => article.id, :author => 'Rawane', :body => 'test'}}
    follow_redirect!

    last_request.url.should == "http://example.org/articles/#{article.id}"
    doc = Nokogiri::HTML(last_response.body)
    doc.css('.comment').count.should == 1
    
    article.comments.count.should == 1
    article.comments.first.author.should == 'Rawane'
    article.comments.first.body.should == 'test'
    
    last_response.should be_ok
  end
  
  it "does not create an article'comment with invalid attributes" do
    article = Parchemin::Article.new('tellus')
    
    post '/comment', {:comment => {:article => article.id, :author => 'Rawane'}}
    
    article.comments.count.should == 0
    
    last_response.should be_ok
  end
  
  it "renders the feeds" do
    get '/rss'

    doc = Nokogiri::XML(last_response.body)
    doc.css('item').count.should == 4
    
    last_response.should be_ok
  end
  
  it "display the application and author's names" do
    get '/'
    last_response.should be_ok
    doc = Nokogiri::HTML(last_response.body)
    doc.css('title').first.content.strip.should == 'Parchemin Test'
    doc.css('.brand').first.content.strip.should == 'Parchemin Test'
    doc.css('.tagline').first.content.strip.should == 'par Rawane ZOSSOU'
    
    get 'articles/lorem'
    last_response.should be_ok
    doc = Nokogiri::HTML(last_response.body)
    doc.css('title').first.content.strip.should == 'Parchemin Test'
    doc.css('.brand').first.content.strip.should == 'Parchemin Test'
    doc.css('.tagline').first.content.strip.should == 'par Rawane ZOSSOU'
    
    get '/tags/tutorial'
    last_response.should be_ok
    doc = Nokogiri::HTML(last_response.body)
    doc.css('title').first.content.strip.should == 'Parchemin Test'
    doc.css('.brand').first.content.strip.should == 'Parchemin Test'
    doc.css('.tagline').first.content.strip.should == 'par Rawane ZOSSOU'
    
    get '/search', {:search => 'lorem ipsum'}
    last_response.should be_ok
    doc = Nokogiri::HTML(last_response.body)
    doc.css('title').first.content.strip.should == 'Parchemin Test'
    doc.css('.brand').first.content.strip.should == 'Parchemin Test'
    doc.css('.tagline').first.content.strip.should == 'par Rawane ZOSSOU'
  end
  
  it "renders statics" do
    get '/statics/about'
    
    doc = Nokogiri::HTML(last_response.body)
    doc.css('title').first.content.strip.should == 'Parchemin Test'
    doc.css('.brand').first.content.strip.should == 'Parchemin Test'
    doc.css('.tagline').first.content.strip.should == 'par Rawane ZOSSOU'
    doc.css('p').count.should == 2
    
    last_response.should be_ok
  end
end
