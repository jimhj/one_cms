CONFIG = YAML.load(File.read(File.expand_path('../../config.yml', __FILE__)))[Rails.env]
