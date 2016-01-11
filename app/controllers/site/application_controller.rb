class Site::ApplicationController < ApplicationController
  layout 'site'

  def index
    @links = Link.where(linkable_id: 0)
  end
end
