class Attachment < ActiveRecord::Base
  has_one :attachedfile, :as => :attachable
  has_one :icon, :as => :attachable
  belongs_to :page, :counter_cache => true
  has_and_belongs_to_many :roles

  def can_be_viewed(user_roles)
     return true
   end

end
