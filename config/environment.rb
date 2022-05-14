# frozen_string_literal: true

require 'bundler/setup'
require 'pry'
Bundler.require

@environment = ENV['RACK_ENV'] || 'development'
@db_config = YAML.load(File.read('config/database.yml'))
ActiveRecord::Base.establish_connection @db_config[@environment]

require_all 'app'

ActiveRecord::Base.logger = nil
