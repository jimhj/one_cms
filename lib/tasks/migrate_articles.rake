namespace :xjd do
  task :migrate_articles => :environment do
    root = H4::Node.find 307
    
    # 栏目
    # root.children.each do |node|
    #   puts "导入栏目 #{node.name}"
    #   n = ::Node.new(node.as_json(except: [:created_at, :updated_at, :lft, :rgt, :depth, :parent_id]))
    #   n.save!

    #   node.children.each do |node2|
    #     puts "导入栏目 #{node2.name}"
    #     n2 = ::Node.new(node2.as_json(except: [:created_at, :updated_at, :lft, :rgt, :depth, :parent_id]))
    #     n2.save!
    #     n2.move_to_child_of(n)
    #   end
    # end

    # 文章
    H4::Article.where(node_id: root.self_and_descendants.pluck(:id)).where('created_at > 2016-02-19 09:18:00').find_in_batches do |articles|
      articles.each do |artc|
        begin
          puts "导入文章 #{artc.title}"

          a = ::Article.new(artc.as_json(except: [:id, :pictures_count, :linked, :hot, :recommend, :thumb]))
          a.save!
          ab = ::ArticleBody.new(artc.article_body.as_json(only: [:body]))
          ab.article_id = a.id
          ab.save!

          sleep(1)
        rescue => e
          next
        end
      end
    end
  end
end