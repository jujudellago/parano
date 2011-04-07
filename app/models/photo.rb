class Photo < ActiveRecord::Base
  belongs_to :gallery, :counter_cache => true
  has_attachment :content_type => :image,
                 :storage => :file_system,
                 :max_size => 5.megabytes,
                 :resize_to => '800x600>',
                 :processor => :Rmagick,
                 :path_prefix =>'/public/photos',
                 :thumbnails => { :thumb => '150x150>' }
  validates_as_attachment

  
end

