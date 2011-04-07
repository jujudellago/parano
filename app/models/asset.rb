class Asset < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true
    #belongs_to :page
    #belongs_to :attachable, :polymorphic => true


  #:resize_to => '500x500>',
  # :resize_to => '640x480',                                                     


end
