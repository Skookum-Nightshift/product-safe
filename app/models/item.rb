class Item < ActiveRecord::Base
  has_one :user, through: :collections
end
