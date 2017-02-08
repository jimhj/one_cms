RestClient.log = Rails.logger

namespace :baidu do
  desc 'notify MIP'
  task :notify_mip => :environment do
    store_path = Rails.root.join('public', 'baidu_mip_record.txt')

    if File.exist?(store_path)
      last_notified_id, rsp_string = File.read(store_path).split(/\n/)

      if last_notified_id.blank?
        last_notified_id = Article.order('id ASC').first.id
      end

    else
      last_notified_id = Article.order('id ASC').first.id
    end

    domain = "www.h4.com.cn"
    mip_domain = "m.h4.com.cn"
    mip_host = "http://#{mip_domain}"

    uri = URI.parse('http://data.zz.baidu.com/urls?site=m.h4.com.cn&token=YaDGPhGkZ31vBqzt&type=mip')
    req = Net::HTTP::Post.new(uri.request_uri)

    articles = Article.where('id > ?', last_notified_id).order('id ASC').limit(700)
    
    return if articles.blank?

    rsp_string = ""

    articles.to_a.in_groups_of(100, false).each do |group|
      urls = group.collect do |article| 
        next if article.node.nil?
        "#{mip_host}/mip/#{article.node.slug}/#{article.id}"
      end
      urls = urls.compact.join("\n")

      req.body = urls
      req.content_type = 'text/plain'
      rsp = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) } rescue '提交错误'
      rsp_string = rsp.body

      sleep(2)
    end

    File.open(store_path, "w+") do |file|
      file.write articles.last.id
      file.write "\n"
      file.write rsp_string
    end
  end
end