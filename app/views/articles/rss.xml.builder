xml.instruct!

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do

    xml.title       "CCFR News"
    xml.link        articles_url
    xml.pubDate     @articles.first.published_at if @articles.any?
    xml.description "News about the CCFR"

    @articles.each do |article|
      xml.item do
        xml.title      "[#{article.language_code}] #{article.category.name}: #{article.title}"
        xml.link        article_url(article)
        xml.description article.synopsis
        xml.pubDate     article.published_at
        xml.guid        article_url(article)
        xml.author      "Smarthub"
      end
    end

  end
end
