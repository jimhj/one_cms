module Mobile::ApplicationHelper
  def simple_pagination
    prev_text = '&#8592; 上一页'
    next_text = '下一页 &#8594;'

    current = (params[:page].presence || 0).to_i
    parameters = request.query_parameters
    prev_page = current - 1
    prev_page = 1 if prev_page <= 0
    next_page = current + 1

    prev_html = %Q(<a href="#{url_for(parameters.merge(page: prev_page))}" class="btn btn-default">#{prev_text}</a>)
    next_html = %Q(<a href="#{url_for(parameters.merge(page: next_page))}" class="btn btn-default">#{next_text}</a>)

    (prev_html + next_html).html_safe
  end
end