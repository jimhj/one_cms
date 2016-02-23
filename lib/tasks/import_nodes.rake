require 'csv'

namespace :nodes do
  task import: :environment do
    Node.transaction do
      cfn = 0
      # CSV.foreach(Rails.root.join('config', 'yuernode.csv').to_s) do |row|
      #   node_name, parent_node_id, node_id, id, slug = row
      #   node_name = node_name.split(' ').last
      #   # next
      #   if Rails.env.development?
      #     parent_node                                  = Node.find_by(id: parent_node_id)
      #     next if parent_node.nil?
      #   else
      #     parent_node                                  = Node.find parent_node_id
      #   end
      #   slug = slug.strip
      #   if Node.find_by(slug: slug)
      #     cfn += 1
      #     slug = slug << node_id
      #   end
      #   node                                         = Node.new
      #   node.id                                      = node_id
      #   node.name                                    = node_name.strip
      #   node.slug                                    = slug
      #   if not node.valid?
      #     p node.errors.full_messages
      #   end
      #   node.save!
      #   node.move_to_child_of(parent_node)
      # end

      CSV.foreach(Rails.root.join('config', 'yuerseo.csv').to_s) do |row|
        desc, keyword, title, id = row[-4], row[-3], row[-2], row[-1]
        p id
        p desc
        p keyword
        p '--------------------'
        next
        node                                  = Node.find_by(id: id)
        next if node.nil?
        
        node.seo_title = title
        node.seo_keywords = keyword
        node.seo_description = desc
        node.save!
      end

      p cfn 
    end
  end
end