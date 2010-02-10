class Feeling
  include DataMapper::Resource
	
	property :id, 				Serial
	property :reason,			Text
	property :love,				Boolean
	property :timestamp, 	String
  property :created_at, DateTime
  property :updated_at, DateTime

	belongs_to :target, 'User', :child_key => [:target_id], :required => false

	class << self
		def loves
			all(:love => true)
		end

		def love_count
			loves.count
		end

		def hates
			all(:love => false)
		end

		def create(*args)
			if args && args[0] && args[0].is_a?(Hash) 
				args[0][:reason] = args[0][:target_name].to_s + args[0][:reason] if args[0][:target].nil?
				args[0].delete(:target_name)
			end
			super(*args)
		end
	end

	def love?
		attribute_get(:love)
	end

	def hate?
		!attribute_get(:love)
	end

	def emotion
		self.love? ? "love" : "hate"
	end

	def to_s
		str = self.emotion.upcase + ": "
		str += if self.has_user?
			"@#{self.target.name}: #{self.reason}"
		else
			self.reason.to_s
		end
	end

	def has_user?
		self.target && YAML::load(File.read("users.yml")).include?(self.target.name)
	end
end
