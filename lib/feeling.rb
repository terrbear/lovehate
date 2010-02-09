class Feeling
  include DataMapper::Resource
	
	property :id, 				Serial
	property :reason,			String
	property :love,				Boolean
  property :created_at, DateTime
  property :updated_at, DateTime

	belongs_to :target, 'User', :child_key => [:target_id]
  
	validates_present :reason

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
end
