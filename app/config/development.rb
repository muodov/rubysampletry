#ENV["DATAMAPPER_URL"] = "sqlite3://#{File.expand_path(File.dirname(__FILE__))}/banners.db"
ENV["DATAMAPPER_URL"] = "mysql://test:test@127.0.0.1/advidi"
DataMapper::Logger.new($stdout, :debug)
#ENV['FORCE_DB_MIGRATE'] = '1'

