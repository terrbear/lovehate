class Feeling
  include DataMapper::Resource
	
	property :id, 				Serial
	property :reason,			Text
	property :love,				Boolean
  property :created_at, DateTime
  property :updated_at, DateTime

	belongs_to :target, 'User', :child_key => [:target_id]

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

	def to_s
		str = self.emotion.upcase + ": "
		str += if self.has_user?
			"@#{self.target.name}: #{self.reason}"
		else
			self.target.name.to_s + " " + self.reason.to_s
		end
	end

	def has_user?
		%w(rod rdejuana rodrigo
		matt mpatterson patterson mepatterson
		mike roeder mroeder
		shane ssherman
		jbell jonbell jon
		dan danh danhiggins
		theath terry
		marc schrifty mschriftman
		elmo elmore steve).include?(self.target.name)
	end
end
