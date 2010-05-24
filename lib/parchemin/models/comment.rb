# coding: utf-8

module Parchemin
  
  # This class represents an article's comment
  class Comment
    include Mongoid::Document
    include Mongoid::Timestamps
    
    field :author
    field :email
    field :website
    field :body
    field :article
    # field :created_at, :type => DateTime
    # field :updated_at, :type => DateTime
    
    validates_presence_of :author, :body, :article
  end
end