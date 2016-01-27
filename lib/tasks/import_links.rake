namespace :h4 do
  task :import_links => :environment do
    File.foreach(Rails.root.join('config', 'links.txt')) do |line|
      line = line.gsub("\n", '')
      name, link = line.split(/\s{1,}/)
      Keyword.create(name: name, url: link, sortrank: 1000)
    end
  end
end