# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
require 'pry'
Bundler.require(:default, ENV['RACK_ENV'])

@environment = ENV['RACK_ENV']
@db_config = YAML.load(File.read('config/database.yml'))
ActiveRecord::Base.establish_connection @db_config[@environment]

require_all 'app'

ActiveRecord::Base.logger = nil
