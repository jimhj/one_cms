class CreateChannelArticles < ActiveRecord::Migration
  def change
    create_table :channel_articles do |t|

      t.timestamps null: false
    end
  end
end
