require 'builder'

namespace :g do
  desc 'Generate sitemap'
  task :sitemap => :environment do
    host = Rails.env.development? ? 'http://127.0.0.1:8000': 'http://www.h4.com.cn'

    file = Rails.root.join('public', 'sitemap.xml').to_s
    xm = Builder::XmlMarkup.new(:ident => 2, :margin => 4)
    xm.instruct!  
    xm.urlset {
      Node.order('sortrank DESC').each do |node|
        xm.url {
          xm.loc File.join(host, node.slug).to_s
          xm.lastmod node.updated_at.strftime('%F')
          xm.changefreq 'daily'
          xm.priority 0.8
        }
      end

      Tag.order('taggings_count DESC').limit(100).each do |tag|
        xm.url {
          xm.loc File.join(host, 'tags', tag.slug).to_s
          xm.lastmod tag.updated_at.strftime('%F')
          xm.changefreq 'daily'
          xm.priority 1.0
        }
      end

      Channel.order('id DESC').limit(100).each do |channel|
        xm.url {
          xm.loc File.join(host, 'z', channel.slug).to_s
          xm.lastmod channel.updated_at.strftime('%F')
          xm.changefreq 'daily'
          xm.priority 1.0
        }
      end

      Article.order('id DESC').limit(100).each do |article|
        xm.url {
          xm.loc File.join(host, article.node.slug, article.id.to_s).to_s
          xm.lastmod article.updated_at.strftime('%F')
          xm.changefreq 'daily'
          xm.priority 1.0
        }
      end           
    }

    xml = xm.to_s.gsub('<to_s/>', '')
    File.open file, 'w+' do |f|
      f.write xml
    end
  end
end