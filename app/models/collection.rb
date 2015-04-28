class Collection < ActiveRecord::Base
  has_one :user
  has_many :items
end
