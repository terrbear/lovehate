require 'magic_key_auth'

class User
  include DataMapper::Resource
  
	property :id,         Serial
  property :name,       String  
  property :created_at, DateTime
  property :updated_at, DateTime

	has n, :feelings, :child_key => [:target_id]

  validates_present :name

	class << self
		def name_from_signature(digest, timestamp)
			raise ArgumentError, "must provide digest and timestamp" if digest.blank? || timestamp.blank?
			MagicKeyAuth::SSL.key_location = "public/keys"
			MagicKeyAuth::SSL.authenticate(:message => timestamp,
																		 :digest => digest)
		end

		def is_username?(name)
			YAML::load(File.read("users.yml")).include?(name)
		end
	end
end
