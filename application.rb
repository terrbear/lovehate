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

get '/' do
  haml :root, 
		:haml_options => {:escape_html => true},
		:locals => {:feelings => Feeling.all(:order => [:created_at.desc], :limit => 18)}
end

post '/love' do
	return feel(true) || "Aww, it loves you too!"
end

post '/hate' do
	return feel(false) || "GRR!"
end

def feel(love)
	if params[:timestamp].blank? || params[:signature].blank? || params[:name].blank?
		return "Required parameters: timestamp, signature, name, reason"
	end

	return "No dupe timestamps, please." if Feeling.first(:timestamp => params[:timestamp])

	target = User.first(:name => params[:name]) \
					|| (User.is_username?(params[:name]) && User.create(:name => params[:name])) \
					|| nil

	feeler = User.name_from_signature(Base64.decode64(params[:signature]), params[:timestamp].to_s)
	return "Could not authenticate with your public key." if feeler.blank?

	Feeling.create(:target => target, :reason => params[:reason] + " [#{feeler}]", :love => love, :timestamp => params[:timestamp])
	false
end
