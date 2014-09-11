APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]
ELASTIC = APP_CONFIG[:elastic]
