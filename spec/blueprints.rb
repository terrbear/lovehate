require 'machinist/data_mapper'
require 'sham'
require 'faker'

Sham.name { Faker::Name.name }

User.blueprint do
	name { Sham.name }
end

Feeling.blueprint do
	target {User.make}
	reason { Faker::Name.name }
end
