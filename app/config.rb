require 'data_mapper'

env = ENV['RACK_ENV']
case env
when 'development'
    require_relative 'config/development'
when 'production'
    require_relative 'config/production'
when 'test'
    require_relative 'config/test'
else
    raise "Unknown environment #{env}!"
end

DataMapper.setup(:default, ENV["DATAMAPPER_URL"])
require_relative 'models'
if ENV['FORCE_DB_MIGRATE']
    puts 'forcing auto_migrate!'
    DataMapper.auto_migrate!
end
DataMapper.finalize

