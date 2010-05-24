# coding: utf-8

module Parchemin
  
  # This class represents a static content such as an about page
  class Static
    attr_reader :filename, :id
    
    # initializes the static content with its name
    def initialize(id)
      @id = id
      @filename = "#{Parchemin::Config.statics_path}/#{@id}.markdown"
    end
    
    # return the body of the static content. It is possible to prevent the markup's interpretation by passing false to the method. It is useful when you only have a paragraph and don't want to see <p></p> around it.
    def body(interpret_markdown=true)
      raise "#{@filename} doesn't exist." if not File.exist?(@filename)
      if interpret_markdown
        @body ||= RDiscount.new(File.read(@filename)).to_html
      else
        @body ||= File.read(@filename)
      end
      @body
    end
  end
end