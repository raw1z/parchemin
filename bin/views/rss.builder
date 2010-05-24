xml.instruct! :xml, :version => '1.0'
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Papyrus"
    xml.description "Par Rawane ZOSSOU"
    xml.link "#{@host}"

    @articles.each do |article|
      xml.item do
        xml.title article.title
        xml.link "#{@host}/articles/#{article.filename}"
        xml.description article.abstract
        xml.pubDate Time.parse(article.created_at.to_s).rfc822()
        xml.guid "#{@host}/articles/#{article.filename}"
      end
    end
  end
end