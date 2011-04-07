class Icon < Asset
  has_attachment DEFAULT_ATTACHMENT_OPTIONS.merge( :resize_to => '600x480',
                                                     :thumbnails => { :thumb => '105', :banner => '180>' ,:tiny=>'50>'}, 
                                                     :path_prefix => "#{BASEPUBLIC_DIR}uploaded_images/",
                                                     :max_size => 5.megabytes,
                                                     :content_type => :image)
  validates_as_attachment
end
