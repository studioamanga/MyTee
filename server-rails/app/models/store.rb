class Store < ActiveRecord::Base
  attr_accessible :address, :name, :storeType
  has_many :tshirts
end
