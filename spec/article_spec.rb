require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Parchemin::Article do
  it "parses its header" do
    article = Parchemin::Article.new('lorem')
    article.title.should == "Lorem ipsum"
    article.created_at.should == Date.civil(2010, 3, 23)
    article.abstract == "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    article.tags.should == ['news', 'sinatra']
    
    article = Parchemin::Article.new('azerty')
    article.title.should == "Cillum facilisis" 
    article.created_at.should == Date.civil(2010, 3, 26)
    article.abstract == "Cillum facilisis metus turpis wisi interdum rutrum, pharetra aenean feugiat velit facilisi penatibus deserunt nonummy praesent blandit. Quisque augue adipiscing penatibus sociosqu eros torquent curabitur, vel praesent consequat aliquet sapien quam adipisicing. A dolore elit luctus scelerisque suspendisse pretium, commodo fringilla mus tellus nulla mollis suspendisse justo enim tempor congue cursus mus."
    article.tags.should == ['editorial', 'rails', 'test']
  end
end