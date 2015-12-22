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
  h4ui/site.js
  h4ui/owl/owl.carousel.css
  h4ui/owl/owl.carousel.js
  index.scss
  site.css
)
