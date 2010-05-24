# coding: utf-8

require 'date'

module Parchemin
  
  # This class represent an article
  class Article
    attr_reader :id, :title, :created_at, :abstract, :body, :filename, :tags

    MONTHS = %w(janv fevr mars avr mai juin juill aout sept oct nov dec)

    # initializes the article with its name
    def initialize(id)
      if id =~ /(.*)\.markdown$/
        @id = $1
      else
        @id = id
      end
      parse_attributes(filename)
    end
    
    # returns the expanded path of the article
    def filename
      "#{Parchemin::Config.articles_path}/#{@id}.markdown"
    end

    # returns the month of the article's creation date
    def month
      MONTHS[@created_at.month-1]
    end

    # returns the day of the article's creation date
    def day
      @created_at.day
    end

    # returns the year of the article's creation date
    def year
      @created_at.year
    end

    # returns a well formatted date
    def date
      "#{day} #{month.capitalize} #{year}"
    end

    # defines the comparison of two articles
    def <=>(article)
      created_at <=> article.created_at
    end

    # returns all the available articles. The articles starting by a '.' are not loaded
    def self.all(conditions={})
      articles = []
      Dir.foreach(Parchemin::Config.articles_path) do |entry|
        next if entry.match /^\./
        article = Article.new(entry)

        if conditions.count == 0
          articles << article
        else
          articles << article if not filtered?(article, conditions)
        end
      end
      articles.sort.reverse
    end

    # a rudimentary search engine
    def self.search(search)
      output = `grep -Hi '#{search}' #{Parchemin::Config.articles_path}/* | cut -d: -f1`
      articles = output.split("\n").uniq.map do |filename|
        Article.new(File.basename(filename))
      end
      articles.sort.reverse
    end
    
    # returns all the comments available for an article
    def comments
      Comment.where(:article => @id)
    end

    protected
    
    def parse_attributes(filename)
      body = ""
      File.open(filename) do |f|
        f.lines.each do |line|
          if line.match /<!--\s(.*)\s-->/
            $1.match /(.*)\s:\s(.*)/
            eval "@#{$1} = #{$2}"
          else
            body += line
          end
        end
      end

      @body = RDiscount.new(body).to_html
    end

    def self.filtered?(article, conditions)
      filtered = true
      conditions.each do |attribute, value|
        if attribute.to_s == 'tag'
          filtered &&= !(article.tags.include?(value))
        else
          filtered &&= !(article.send(attribute) == value)
        end
      end
      filtered
    end
  end
end
