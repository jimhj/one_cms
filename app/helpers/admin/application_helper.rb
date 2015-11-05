module Admin
  module ApplicationHelper
    def notice_message
      flash_messages = []

      flash.each do |type, message|
        type = :success if type.to_sym == :notice
        type = :danger if type.to_sym == :alert
        text = content_tag(:div, link_to('x', '#', :class => 'close', 'data-dismiss' => 'alert') + message, class: "alert alert-#{type}")
        flash_messages << text if message
      end

      flash_messages.join("\n").html_safe
    end
  end
end
