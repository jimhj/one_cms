# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(
  admin/app.js
  admin/app.css
  site/themes/green.css
  site/themes/orange.css
  site/themes/red.css
  site/app.js
  bootstrap-ie7.css
  respond.js
  html5shiv.js
  font-awesome-ie7
  mobile/app.js
  mobile/themes/green.css
  mobile/themes/orange.css
  mobile/themes/red.css
  mobile/wechat-article.css
  swiper.js
  swiper.css
  tt/app.css
  tt/views/index.css
  tt/app.js
  tt/index.js
  jquery.slideBox.js
  jquery.slideBox.css
)

Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)\z/
