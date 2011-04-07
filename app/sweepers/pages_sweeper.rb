class PagesSweeper < ActionController::Caching::Sweeper
  observe Page
  def after_save(page)
    # expire_action_content('/pages')
    #  expire_action_content("/pages/#{record.id}-#{record.permalink}")
    #  
    expire_cache(page)
  end

  def after_destroy(page)
    expire_cache(page)
  end

  def expire_cache(page)

    topnav="top_nav-"
    expire_fragment(topnav)

    page_links="pagelinks-#{page.parent.id.to_s}-"
    expire_fragment(page_links)

    page_attachments="pageattachments-#{page.id.to_s}-"
    expire_fragment(page_attachments)

    page_content="page-#{page.id.to_s}"
    expire_fragment(page_content)
    # RAILS_DEFAULT_LOGGER.error("\n pages_sweeper delete page_content Fragment #{page_content}  \n")

    sitemap="sitemap-"
    expire_fragment(sitemap)

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