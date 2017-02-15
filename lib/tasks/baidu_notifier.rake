RestClient.log = Rails.logger

def mip_domain
  Setting.mobile_domain.gsub('http://', '')
end

def mip_host
  "http://#{mip_domain}"
end

def post(urls)
  uri = URI.parse("http://data.zz.baidu.com/urls?site=#{mip_domain}&token=#{Setting.baidu_notify_token}&type=mip")
  req = Net::HTTP::Post.new(uri.request_uri)
  req.body = urls
  req.content_type = 'text/plain'
  rsp = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }
  ActiveSupport::JSON.decode(rsp.body) rescue { "error" => 500, "message" => "提交失败" }
end

def record_store_path
  Rails.root.join('public', 'baidu_mip_record.txt')
end

def refresh_remains(last_record_id)
  article = Article.where('id > ?', last_record_id).order('id ASC').limit(1).first

  if article.node.blank?
    article.update_column(:node_id, 1)
    article.reload
  end

  urls = "#{mip_host}/mip/#{article.node.slug}/#{article.id}"
  rsp = post(urls)

  [rsp, article.id]
end

namespace :baidu do
  desc 'notify MIP'
  task :notify_mip => :environment do
    last_record_id = File.read(record_store_path).split(/\n/).first
    last_record_id ||= 1
    submit_number = 0
    total = { "remain" => '', "success" => '' }
    remain = 0
    error = ""

    total, requested_id = refresh_remains(last_record_id)

    if total['error'].present?
      error = total["message"]
    else
      articles = Article.where('id > ?', requested_id).order('id ASC').limit(total['remain'])
      articles.to_a.in_groups_of(50, false).each do |group|
        urls = group.collect do |article| 
          next if article.node.nil?
          "#{mip_host}/mip/#{article.node.slug}/#{article.id}"
        end.compact.join("\n")

        r = post(urls) rescue break

        if r['error'].present?
          errors = r["message"]
          break
        end

        last_record_id = group.last.id
        submit_number += r["success"].to_i
        remain = r["remain"]

        sleep(2)
      end
    end

    File.open(record_store_path, "w+") do |file|
      file.write([last_record_id, submit_number, total, remain, error].join("\n"))
    end
  end
end