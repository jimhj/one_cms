class DiscuzKeyword
  class << self
    def analyze(title, content)
      params = {
        title: title,
        content: ActionView::Base.full_sanitizer.sanitize(content).first(800),
        ics: 'utf-8',
        ocs: 'utf-8'
      }

      rsp = RestClient.get "http://keyword.discuz.com/related_kw.html?#{params.to_query}"
      Hash.from_xml(rsp)
    end
  end
end