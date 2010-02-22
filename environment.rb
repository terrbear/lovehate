require 'rubygems'
gem 'dm-core', '0.10.2'
gem 'dm-validations', '0.10.2'
gem 'dm-aggregates', '0.10.2'
gem 'data_objects', '0.10.1'

%w(dm-core dm-timestamps data_objects data_objects dm-validations dm-aggregates haml ostruct).each do |gem|
	begin
		require gem
	rescue Gem::LoadError => ge
		next
	end
end

require 'sinatra' unless defined?(Sinatra)

configure do
  SiteConfig = OpenStruct.new(
                 :title => 'Your Application Name',
                 :author => 'Your Name',
                 :url_base => 'http://localhost:4567/'
               )

	sqlite3_file = "sqlite3:///#{File.expand_path(File.dirname(__FILE__))}/#{Sinatra::Base.environment}.db"
	DataMapper.setup(:default, ENV['DATABASE_URL'] || sqlite3_file)

  # load models
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| require File.basename(lib, '.*') }
end
