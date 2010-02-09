require "#{File.dirname(__FILE__)}/spec_helper"

describe 'main application' do
  include Rack::Test::Methods

  def app
    Sinatra::Application.new
  end

  specify 'should show the default index page' do
    get '/'
    last_response.should be_ok
  end
end

describe 'love action' do
  include Rack::Test::Methods

  def app
    Sinatra::Application.new
  end

	before(:each) do
		@theath = User.make(:name => "theath")
		@timestamp = Time.now.utc.to_i.to_s
		signer = EzCrypto::Signer.from_file("/Users/theath/.ssh/id_rsa")
		@signature = Base64.encode64(signer.sign(@timestamp))
		@name = "theath"
		@params = {:timestamp => @timestamp, :signature => @signature,
							:name => @name, :reason => "so cool"}
	end

	it 'should tell you if not all params are present' do
		post '/love'
		last_response.body.should == "Required parameters: timestamp, signature, name, reason"
	end

	it 'should create a love feeling' do
		lambda {
			post '/love', @params
		}.should change(Feeling, :love_count)
	end

	it "should create a user if it doesn't exist" do
		lambda {
			post '/love', @params.merge(:name => "rod")
		}.should change(User, :count)
	end

	it "should tell you if your key isn't found" do
		post '/love', @params.merge(:signature => "blah whatevz")
		last_response.body.should == "Could not authenticate with your public key."
	end
end
