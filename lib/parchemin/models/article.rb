# coding: utf-8

require 'date'

module Parchemin
  class Article
    attr_reader :id, :title, :created_at, :abstract, :body, :filename, :tags

    MONTHS = %w(janv fevr mars avr mai juin juill aout sept oct nov dec)

    def initialize(id)
      if id =~ /(.*)\.markdown$/
        @id = $1
      else
        @id = id
      end
      parse_attributes(filename)
    end
    
    def filename
      "#{Parchemin::Config.articles_path}/#{@id}.markdown"
    end

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

    def month
      MONTHS[@created_at.month-1]
    end

    def day
      @created_at.day
    end

    def year
      @created_at.year
    end

    def date
      "#{day} #{month.capitalize} #{year}"
    end

    def <=>(article)
      created_at <=> article.created_at
    end

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

    def self.search(search)
      output = `grep -Hi '#{search}' #{Parchemin::Config.articles_path}/* | cut -d: -f1`
      articles = output.split("\n").uniq.map do |filename|
        Article.new(File.basename(filename))
      end
      articles.sort.reverse
    end
    
    def comments
      Comment.where(:article => @id)
    end

    protected

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
