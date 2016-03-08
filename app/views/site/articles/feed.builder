xml.instruct! :xml, version: "1.0"
xml.rss(version: "2.0"){
  xml.channel{
    xml.title SiteConfig.actived.site_name
    xml.link root_url
    xml.description(SiteConfig.actived.site_description)
    xml.language('en-us')
    # for article in @articles
    @articles.each do |article|
      next if article.node.nil?
      xml.item do
        xml.title article.title
        xml.description raw(article.article_body.body_html)
        xml.author article.writer
        xml.pubDate(article.created_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
        xml.link article_url article
        xml.guid article_url article
      end
    end
  }
}
