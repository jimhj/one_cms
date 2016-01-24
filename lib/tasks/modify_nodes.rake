require 'csv'

namespace :nodes do
  task :update => :environment do
    CSV.foreach(Rails.root.join('config', 'nodes.csv').to_s) do |row|
      begin
        node = Node.find row.first.to_i
        node.update_attribute :slug, row[1]
        puts node.slug
      rescue
        next
      end
    end
  end
end