class Gallery < ActiveRecord::Base
  has_many :photos
  translates :name, :description
end
