class Image < Asset
  has_attachment DEFAULT_ATTACHMENT_OPTIONS.merge( :resize_to => '490x490>',
                                                     :thumbnails => { :thumb => '100x100>' }, 
                                                     :path_prefix => "#{BASEPUBLIC_DIR}uploaded_images/",
                                                     :max_size => 5.megabytes,
                                                     :content_type => :image)
      validates_as_attachment                                                  
  #belongs_to :page
#   belongs_to :attachable, :polymorphic => true
#   has_attachment DEFAULT_ATTACHMENT_OPTIONS.merge( :resize_to => '500x500>',
#                                                      :thumbnails => { :thumb => '100x100>' }, 
#                                                      :path_prefix => '/public/uploaded_images/',
#                                                      :max_size => 5.megabytes,
#                                                      :content_type => :image)
#                                                      
# #:resize_to => '500x500>',
# # :resize_to => '640x480',                                                     
# 
#   validates_as_attachment
  
end
