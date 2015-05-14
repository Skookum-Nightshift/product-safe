class Item < ActiveRecord::Base
  belongs_to :collection
  has_one :user, through: :collections

  fuzzily_searchable :name
end

