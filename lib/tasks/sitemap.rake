require 'builder'

namespace :g do
  desc 'Generate sitemap'
  task :sitemap => :environment do
    host = Rails.env.development? ? 'http://127.0.0.1:8000': "http://#{SiteConfig.actived.domain || 'www.h4.com.cn'}"
    index_file = Rails.root.join('public', 'sitemap.xml').to_s
    sitemap_file_dir = Rails.root.join('public', 'sitemap').to_s
    # if File.directory?(sitemap_file_dir)
    #   FileUtils.remove_dir(sitemap_file_dir)
    # end
    # FileUtils.mkdir_p(sitemap_file_dir)

    index_xm = Builder::XmlMarkup.new(:ident => 2, :margin => 4)
    index_xm.instruct!  
    index_xm.sitemapindex {
      Node.all.order('id DESC').each_with_index do |node, ind|
        node_id = node.id
        node_ids = node.self_and_descendants.pluck(:id)
        count = Article.where(node_id: node_ids).count
        next if count.zero?

        size = count / 10000
        size = size + 1
        size = 10 if size >= 10
        1.upto(size ).each do |page|
          loc = "sitemap/#{node_id}-#{page}.xml"
          # file = Rails.root.join('public', loc).to_s
          # xm = Builder::XmlMarkup.new(:ident => 2, :margin => 4)
          # xm.instruct! 
          # xm.urlset {
          #   articles.each do |article|
          #     next if article.node.nil?

          #     xm.url {
          #       xm.loc File.join(host, article.node.slug, article.id.to_s).to_s
          #       xm.lastmod article.updated_at.strftime('%F')
          #       xm.changefreq 'daily'
          #       xm.priority 1.0
          #     }
          #   end 
          # }

          # xml = xm.to_s.gsub('<to_s/>', '')
          # File.open file, 'w+' do |f|
          #   f.write xml
          # end

          index_xm.sitemap {
            index_xm.loc File.join(host, loc).to_s
            index_xm.lastmod Time.now.strftime('%F')
          }
        end
      end
    }

    File.open index_file, 'w+' do |f|
      f.write index_xm.to_s.gsub('<to_s/>', '')
    end
  end
end
