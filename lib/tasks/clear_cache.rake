namespace :clear do
  task :cache => :environment do
    caches = ['desktop/index', 'mobile/index']
    caches.each do |cache_path|
      path = Rails.root.join(cache_path).to_s
      File.delete(path) if File.exist?(path)
      File.delete(path + '.gz') if File.exist?(path + '.gz')
    end
  end
end