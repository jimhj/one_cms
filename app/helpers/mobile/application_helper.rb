module Mobile::ApplicationHelper
  def simple_pagination
    prev_text = '&#8592; 上一页'
    next_text = '下一页 &#8594;'

    current = (params[:page].presence || 0).to_i
    parameters = request.query_parameters
    prev_page = current - (current <= 1 ? 0 : 1)
    next_page = current + (current.zero? ? 2 : 1)

    prev_html = %Q(<a href="#{url_for(parameters.merge(page: prev_page))}" class="btn btn-default">#{prev_text}</a>)
    next_html = %Q(<a href="#{url_for(parameters.merge(page: next_page))}" class="btn btn-default">#{next_text}</a>)

    (prev_html + next_html).html_safe
  end

  def replace_inner_link_domain(html)
    html = html.gsub(/(www\.)?h4\.com\.cn/, 'm.h4.com.cn')
    raw html
  end
end