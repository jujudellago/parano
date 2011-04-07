class Category < ActiveRecord::Base
  has_many :articles, :dependent => :nullify
  validates_length_of :name, :maximum => 80
  acts_as_list  :order => "position" 
  def before_create
    name_no_accents=JujuHelper.clean_accents_for_urls(name)
    @attributes['permalink'] = name_no_accents.downcase.gsub(/\s+/, '_').gsub(/[^a-zA-Z0-9_]+/, '')
  end
  
 
  
end
