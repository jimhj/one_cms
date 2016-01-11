class CreateChannelArticles < ActiveRecord::Migration
  def change
    create_table :channel_articles do |t|
      t.belongs_to :channel, index: true
      t.belongs_to :article, index: true
      t.timestamps null: false
    end
  end
end
