require "#{File.dirname(__FILE__)}/spec_helper"
require 'ezsig'

describe 'user' do
	before(:each) do
		@user = User.new(:name => "blizam")
	end

	specify "should be valid" do
		@user.should be_valid
	end

	specify 'should require a name' do
    @user = User.new
    @user.should_not be_valid
    @user.errors[:name].should include("Name must not be blank")
  end

	specify "should work with machinist" do
		User.make
	end
end

describe 'key lookup method' do
	it "should return nil if no key found" do
		User.name_from_signature("blah", Time.now.utc.to_i.to_s).should be_nil
	end

	specify "should raise argument error if no timestamp or digest" do
		lambda{User.name_from_signature(nil, nil)}.should raise_error(ArgumentError)
	end

	specify "should work for theath's key" do
		signer = EzCrypto::Signer.from_file("/Users/theath/.ssh/id_rsa")
		timestamp = Time.now.utc.to_i.to_s
		User.name_from_signature(signer.sign(timestamp), timestamp).should == 'theath'
	end
end
