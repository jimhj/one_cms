class ChannelArticle < ActiveRecord::Base
  belongs_to :channel
  belongs_to :article
end
