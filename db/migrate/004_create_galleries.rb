class CreateGalleries < ActiveRecord::Migration
  def self.up
    create_table "photos", :force => true do |t|
       t.column "parent_id",    :integer
       t.column "content_type", :string
       t.column "filename",     :string
       t.column "thumbnail",    :string
       t.column "size",         :integer
       t.column "width",        :integer
       t.column "height",       :integer
       t.column "position",     :integer
       t.column "gallery_id",   :integer
       t.column "name",         :string
       t.column "legend",       :string
     end
    
    
     create_table "galleries", :force => true do |t|
       t.column "name",             :string
       t.column "created_at",       :datetime
       t.column "updated_at",       :datetime
       t.column "description",      :text
       t.column "photos_count",     :integer,  :default => 0
       t.column "default_photo_id", :integer
     end
    
  end

  def self.down
    drop_table :photos
    drop_table :galleries
  end
end
