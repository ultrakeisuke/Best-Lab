source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
gem 'puma', '~> 5.0'
gem 'bootstrap-sass'
gem 'sass-rails', '>= 6.0.0'
gem 'webpacker', '~> 4.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  gem 'sqlite3', '1.3.13'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'activerecord-import'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'rails-controller-testing'
  gem 'database_rewinder'
  gem 'simplecov'
end

group :production do
  gem 'pg', '1.2.3'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'devise'
gem 'rails-i18n'
gem 'carrierwave'
gem 'mini_magick'
gem 'kaminari'
gem 'enum_help'
gem 'faker'