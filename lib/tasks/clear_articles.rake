namespace :articles do
  task :clear => :environment do
    # articles = Article.find_by_sql
    checked_aid = SiteConfig.actived.checked_aid.to_i
    checked_aid = 1 if checked_aid.zero?
    articles = Article.where('id > ?', checked_aid).order('id ASC').limit(10000)
  end
end