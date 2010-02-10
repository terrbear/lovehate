require "#{File.dirname(__FILE__)}/spec_helper"

describe 'feeling' do
	before(:each) do
		@feeler = User.create(:name => "feeler")
		@target = User.create(:name => "target")
		@feeling = Feeling.new(:reason => "blam", 
													 :target => @target)
		#@feeling.save!
	end

	specify "should be valid" do
		@feeling.should be_valid
	end

	specify "should save" do
		@feeling.save!
	end

	specify "should work with machinist" do
		Feeling.make
	end

	specify "should be able to get target" do
		Feeling.make.target.should_not be_nil
	end

	it "should allow nil targets" do
		Feeling.new(:reason => "evs").save!
	end
end
