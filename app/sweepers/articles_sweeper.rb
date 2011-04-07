class ArticlesSweeper < ActionController::Caching::Sweeper
  observe Article
  def after_save(article)
    # expire_action_content('/articles')
    #  expire_action_content("/articles/#{record.id}-#{record.permalink}")
    #  
    expire_cache(article)
  end
  
  def after_destroy(article)
    expire_cache(article)
  end
  
  def expire_cache(article)

      archive="archives-#{article.category_id}-"
        expire_fragment(archive)
       # RAILS_DEFAULT_LOGGER.error("\n articles_sweeper delete archive Fragment #{archive}  \n")

  end
  
 
  
end


#  roles 
# +----+--------------------------+
# | id | name                     |
# +----+--------------------------+
# |  1 | admin                    | 
# |  2 | editor                   | 
# |  3 | Membres                  | 
# |  4 | Conseil d'administration | 
# |  5 | ComitÃ© ExÃ©cutif        |