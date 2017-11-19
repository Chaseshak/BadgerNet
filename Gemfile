source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Flexible user authentication: https://github.com/plataformatec/devise
gem 'devise', '~> 4.3.0'
# Authorization OO library https://github.com/elabs/pundit
gem 'authority', '~> 3.3.0'
# Role management library https://github.com/RolifyCommunity/rolify
gem 'rolify', '~> 5.1.0'
# Twilio texting
gem 'twilio-ruby', '~> 5.4.2'

# Rubocop is a Ruby linter Read more: https://github.com/bbatsov/rubocop
gem 'rubocop', '~> 0.50.0', require: false

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Document Handling
gem 'carrierwave'
gem 'bootstrap-sass'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 9.1.0', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'coveralls', '~> 0.7.1', require: false
  gem 'rspec-rails', '~> 3.6'
  gem 'rails-controller-testing', '~> 1.0.2'
  gem 'factory_girl_rails', '~> 4.8.0'
  gem 'selenium-webdriver', '~> 3.6.0'
  gem 'simplecov', '~> 0.15.1', require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
