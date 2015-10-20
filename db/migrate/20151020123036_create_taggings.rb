class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.belongs_to :article, index: true
      t.belongs_to :tag, index: true
      t.datetime :created_at
    end

    add_index :taggings, [:article_id, :tag_id]
  end
end
