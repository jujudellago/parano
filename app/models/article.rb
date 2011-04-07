class Article < ActiveRecord::Base
  belongs_to :category
  validates_presence_of :body, :title
  validates_length_of :title, :maximum => 255
  has_one :icon, :as => :attachable
  before_save :update_published_at_and_permalink, :cleanup_code
  acts_as_list  :order => "position" 
  
  
  
  def update_published_at_and_permalink
    #self.published_at = Time.now if published == true
    self.permalink = self.title.downcase.gsub(/\s+/, '_').gsub(/[^a-zA-Z0-9_]+/, '')
  end
  def before_create
    title_no_accents=JujuHelper.clean_accents_for_urls(title)
    @attributes['permalink'] = title_no_accents.downcase.gsub(/\s+/, '_').gsub(/[^a-zA-Z0-9_]+/, '')
  end

  def display_date
    if self.event_date
      self.event_date
    else
      self.published_at
    end
  end

  def self.find_all_for_archive
    order="published_at desc" 
    find_all_by_published(true,:order=>order)
  end


  def to_param
    "#{id}-#{permalink}"
  end

  def display_description
   self.synopsis.blank? ? self.body[0,80] :self.synopsis
  end
  def display_link
    " > "+self.category.name+" > "+self.title
  end
  
  def self.per_page
    10  
  end

  protected
  def cleanup_code
    self.body   =HtmlCleaner.format_user_text(body)    if attribute_present?("body")
    self.synopsis   =HtmlCleaner.format_user_text(synopsis)    if attribute_present?("synopsis")
  end
end
