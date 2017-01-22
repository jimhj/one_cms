module Mobile::ApplicationHelper
  def simple_pagination
    prev_text = '&#8592; 上一页'
    next_text = '下一页 &#8594;'

    current = (params[:page].presence || 0).to_i
    parameters = request.query_parameters
    prev_page = current - (current <= 1 ? 0 : 1)
    next_page = current + (current.zero? ? 2 : 1)

    prev_html = %Q(<a href="#{url_for(parameters.merge(page: prev_page))}" class="page-btn">#{prev_text}</a>)
    next_html = %Q(<a href="#{url_for(parameters.merge(page: next_page))}" class="page-btn">#{next_text}</a>)

    (prev_html + next_html).html_safe
  end

  def mip_simple_pagination
    prev_text = '&#8592; 上一页'
    next_text = '下一页 &#8594;'

    current = (params[:page].presence || 0).to_i
    parameters = request.query_parameters
    prev_page = current - (current <= 1 ? 0 : 1)
    next_page = current + (current.zero? ? 2 : 1)

    prev_html = %Q(<mip-link href="#{url_for(parameters.merge(page: prev_page, only_path: false))}" class="page-btn">#{prev_text}</mip-link>)
    next_html = %Q(<mip-link href="#{url_for(parameters.merge(page: next_page, only_path: false))}" class="page-btn">#{next_text}</mip-link>)

    (prev_html + next_html).html_safe
  end

  def replace_inner_link_domain(html)
    domain = SiteConfig.actived.domain
    nake_domain = domain.gsub(/www\./, '')
    html = html.gsub(domain, "m.#{nake_domain}")
    html.html_safe
  end

  # def replace_inner_link_domain_mip(html)
  #   domain = SiteConfig.actived.domain
  #   nake_domain = domain.gsub(/www\./, '')
  #   html = html.gsub(domain, "m.#{nake_domain}")
  #   raw html 
  # end

  def replace_mip_images(html)
    domain = SiteConfig.actived.domain
    nake_domain = domain.gsub(/www\./, '')
    html = html.gsub(domain, "m.#{nake_domain}/mip")
    html = html.gsub(/\<img.*?src="(.*?)".*\>/, '<mip-img src="\1" layout="container" popup></mip-img>')
    html.html_safe
  end
end