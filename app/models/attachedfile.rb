class Attachedfile < Asset
  has_attachment DEFAULT_ATTACHMENT_OPTIONS.merge( :resize_to => '500x500>',
                                                     :thumbnails => { :thumb => '100x100>', :banner => '150x150>' }, 
                                                     :path_prefix => "#{BASEPUBLIC_DIR}uploaded_files/",
                                                     :max_size => 5.megabytes)
                                                      #:content_type => ['application/pdf', 'application/msword','application/msexcel', 'text/plain',:image]
  validates_as_attachment                                            
end
