# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.0.0'

gem 'activerecord'
gem 'bcrypt'
gem 'rake'
gem 'require_all'
gem 'sinatra-activerecord'
gem 'sqlite3'
gem 'tty-prompt'

group :development do
  gem 'rubocop'
  gem 'rubocop-rake'
  gem 'rubocop-rspec'
end

group :development, :test do
  gem 'factory_bot'
  gem 'pry'
  gem 'rack-test'
end

group :test do
  gem 'rspec'
  gem 'database_cleaner-active_record'
end
