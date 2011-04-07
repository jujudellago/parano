class Page < ActiveRecord::Base
  validates_presence_of :title
  validates_length_of :title, :within => 3..255
  # validates_length_of :body, :maximum => 10000
  acts_as_tree :order => "position"
  has_many :images, :as => :attachable
  has_many :attachments
  before_save :cleanup_code



  def before_create
    @attributes['permalink'] = 
    title.downcase.gsub(/\s+/, '_').gsub(/[^a-zA-Z0-9_]+/, '')
  end

  def def_keywords
    unless self.keywords.blank?
      self.keywords
    else
      if self.parent && !self.parent.keywords.blank?
        self.parent.keywords
      end
    end
  end
  def def_description
    unless self.description.blank?
      self.description
    else
      if self.parent && !self.parent.description.blank?
        self.parent.description
      end
    end
  end

  def to_param
    "#{id}-#{permalink}"
  end

 


  def display_link
    self.parent ? " > "+self.parent.title+" > "+self.title : " > "+self.title
  end


  def can_be_viewed(user_roles)
   
      return true
 
  end

  protected
  def cleanup_code
    self.body   =HtmlCleaner.format_user_text(body)    if attribute_present?("body")
  end
end



