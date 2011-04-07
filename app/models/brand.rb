class Brand < ActiveRecord::Base
  validates_presence_of :name
  validates_length_of :name, :maximum => 255
  has_one :icon, :as => :attachable



end
