class Site::ApplicationController < ApplicationController
  layout 'site'

  # caches_action :index

  def index
        p request.user_agent.to_s =~ /Mobile|webOS/

    @links = Link.where(linkable_id: 0)
  end
end
