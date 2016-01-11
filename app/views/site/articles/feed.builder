xml.instruct! :xml, version: "1.0"
xml.rss(version: "2.0"){
  xml.channel{
    xml.title '健康私房话'
    xml.link root_url
    xml.description('健康私房话专注健康养生保健,饮食健康,减肥瘦身,美容养颜,疾病咨询,健康服务,健康管理等健康私房话服务领域，是高端的、专注的、个性化的健康管理网站')
    xml.language('en-us')
      for article in @articles
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
