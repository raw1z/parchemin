# coding: utf-8

require 'date'

module Parchemin
  class Article
    attr_reader :title, :created_at, :abstract, :body, :filename, :tags

    MONTHS = %w(janv fevr mars avr mai juin juill aout sept oct nov dec)

    def initialize(filename)
      @filename = filename.split('.').first
      parse_attributes(filename)
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
    
    def id
      File.basename(filename)
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
        article = Article.new("#{Parchemin::Config.articles_path}/#{entry}")

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
      articles = output.split("\n").uniq.map { |filename| Article.new(filename) }
      articles.sort.reverse
    end
    
    def comments
      Comment.where(:article => @filename)
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
