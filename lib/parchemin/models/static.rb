# coding: utf-8

module Parchemin
  class Static
    attr_reader :filename, :id
    
    def initialize(id)
      @id = id
      @filename = "#{Parchemin::Config.statics_path}/#{@id}.markdown"
    end
    
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