ENV["DATAMAPPER_URL"] = "sqlite3::memory:"
DataMapper::Logger.new($stdout, :debug)
ENV['FORCE_DB_MIGRATE'] = '1'

