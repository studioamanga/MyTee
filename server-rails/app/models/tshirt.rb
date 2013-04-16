class Tshirt < ActiveRecord::Base
  attr_accessible :color, :condition, :image_url, :name, :note, :rating, :size, :tags
  belongs_to :store
end