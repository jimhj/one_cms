require 'pp'

def traverse_node(from_node, legacy_nodes)
  legacy_nodes.each do |node|
    puts "====== #{node.typename} - #{node.root.try(:typename)} ="
    n                 = ::Node.new
    n.name            = node.typename
    n.slug            = node.typedir.split('/').last
    n.seo_keywords    = node.keywords
    n.seo_title       = node.seotitle
    n.seo_description = node.description
    n.sortrank        = node.sortrank
    if not n.valid?
      p n.errors.full_messages
    end
    n.save!
    n.move_to_child_of(from_node)

    if node.children.present?
      traverse_node(n, node.children)
    else
      next
    end
  end
end

namespace :legacy do
  desc 'Migrate Legacy Data'
  task migrate: :environment do

    puts "======== 迁移关键词 ======="
    Legacy::Keyword.all.each do |keyword|
      puts "关键词: #{keyword.keyword}"

      k          = ::Keyword.new
      k.name     = keyword.keyword
      k.url      = keyword.rpurl
      k.sortrank = keyword.rank
      k.save!
    end
    puts "\n\n\n"

    puts "======== 迁移栏目 ========="
    Legacy::Node.main.each_with_index do |node, i|
      puts "====== #{node.typename} ="

      n                 = ::Node.new
      n.name            = node.typename
      n.slug            = node.typedir.split('/').last
      n.seo_keywords    = node.keywords
      n.seo_title       = node.seotitle
      n.seo_description = node.description
      n.sortrank        = node.sortrank
      n.save!

      traverse_node(n, node.children)
    end
    puts "\n\n\n"

    puts "======== 迁移文章 ========="
    failed = []
    index = 0
    batch_size = Rails.env.development? ? 300 : 1000
    Legacy::Article.where(typeid: 28).find_in_batches(batch_size: batch_size).with_index do |articles, ind|
      articles.each do |article|
        begin
          Article.transaction do
            puts "开始导入第 #{index + 1} 篇文章 id: #{article.id} ============"
            file               = article.pictures.first.try(:fullurl)

            node_name          = article.node.typename
            node               = ::Node.find_by(name: node_name)
            a                  = node.articles.build
            a.id               = article.id
            a.title            = article.title
            a.sort_rank        = article.sortrank
            a.writer           = article.writer
            a.source           = article.source

            if file
              puts "图片 #{file}"
              if Rails.env.development?
                a.remote_thumb_url = file
              else
                _t                 = MiniMagick::Image.open(file)
                a.thumb            = _t
              end
            end

            a.seo_description  = article.description
            if not a.valid?
              p a.errors.full_messages
            end      
            a.save!
            _t                 = nil
            
            b                  = a.build_article_body
            b.body             = article.article_body.body

            if not b.valid?
              p b.errors.full_messages
            end 
            b.save!

            index += 1
            sleep(2)
          end
        rescue => e
          puts e.backtrace.join("\n")
          failed << article.id
          next
        end
      end

      break if Rails.env.development?
    end
    puts "\n\n\n"

    puts "======== 迁移专题 ========="
    Legacy::Channel.find_in_batches.with_index do |channels|
      channels.each do |channel|
        puts "==== 专题: #{channel.name}"

        c                 = ::Channel.new
        c.name            = channel.name
        c.seo_keywords    = channel.keywords
        c.seo_description = channel.name
        if c.valid?
          c.save
        else
          p c.errors.full_messages
          next
        end
      end

      break if Rails.env.development?
    end 

    puts "\n\n\n"
    puts "失败的文章: #{failed}"
  end
end