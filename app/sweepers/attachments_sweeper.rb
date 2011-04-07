class AttachmentsSweeper < ActionController::Caching::Sweeper
  observe Attachment
  def after_save(attachment)
    expire_cache(attachment)
  end

  def after_destroy(attachment)
    expire_cache(attachment)
  end

  def expire_cache(attachment)
    lngs= get_languages("")
   # RAILS_DEFAULT_LOGGER.error("\n attachments_sweeper lngs = #{lngs}  \n")
    if attachment && lngs
      lngs.each do |ss|
        get_roles_combinations(ss).each do |s|
          page_attachments="pageattachments-#{attachment.page.id.to_s}-"+s
          expire_fragment(page_attachments)
       #   RAILS_DEFAULT_LOGGER.error("\n attachments_sweeper delete page_attachments Fragment #{page_attachments}  \n")
    
          sitemap="sitemap-"+s
          expire_fragment(sitemap)
         # RAILS_DEFAULT_LOGGER.error("\n pages_sweeper delete sitemap Fragment #{sitemap}  \n")
        end
      end
    end
  
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