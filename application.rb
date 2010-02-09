require 'rubygems'
require 'sinatra'
require 'environment'
require 'base64'

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
end

error do
  e = request.env['sinatra.error']
  Kernel.puts e.backtrace.join("\n")
  'Application error'
end

helpers do
  # add your helpers here
end

# root page
get '/' do
  haml :root, :locals => {:feelings => Feeling.all(:order => [:created_at.desc], :limit => 10)}
end

post '/love' do
	puts "params: #{params.inspect}"
	return feel(true)
end

post '/hate' do
	return feel(false)
end

def feel(love)
	if params[:timestamp].blank? || params[:signature].blank? || params[:name].blank? || params[:reason].blank?
		return "Required parameters: timestamp, signature, name, reason"
	end
	target = User.first(:name => params[:name]) || User.create(:name => params[:name])
	feeler = User.name_from_signature(Base64.decode64(params[:signature]), params[:timestamp].to_s)
	return "Could not authenticate with your public key. #{params.inspect}" if feeler.blank?
	target.feelings.create(:reason => params[:reason] + " [#{feeler}]", :love => love)
	return "Feeling added. Don't you feel good?"
end
