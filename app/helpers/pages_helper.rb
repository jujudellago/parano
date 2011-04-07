module PagesHelper
  #get_sub_page_menu(page,false,true,nil,true)  
  def get_sub_page_menu(parent,show_first=true,with_attachments=false,css_class=nil,tinymce=false)
    klass=css_class.nil? ? "" : " class=\"#{css_class}\"" 
    something=false
    ret=""
    ret<<"\n<ul #{klass}>"
    if show_first
      something=true
      ret<<"\n\t<li>"
      if tinymce
         ret<<link_to_function(parent.title,"window.opener.document.getElementById('href').value='#{page_path(parent)}';window.close()") 
      else
        ret<<link_to(parent.title,formatted_page_path(parent,:html))
      end
      ret<<"\n\t</li>"
    end
    sub_pages = Page.find_all_by_parent_id_and_enabled( parent.id,true,:order=>'position')
    sub_pages.each do |sub_page|
      if sub_page.can_be_viewed(session[:current_user_roles])
        something=true
        ret<<"\n\t<li>"
        if tinymce
            ret<<link_to_function(sub_page.title,"window.opener.document.getElementById('href').value='#{page_path(sub_page)}';window.close()") 
        else
           ret<<link_to(sub_page.title,formatted_page_path(sub_page,:html))
        end
        if  with_attachments
          ret<<get_page_attachments(sub_page,false,false,tinymce)
        end
        ret<<"\n\t</li>"
      end
    end
    ret<<"\n</ul>"
    return ret if something
  end

  def get_page_attachments(page,with_edit_links=true, hide_dots=false,tinymce=false)
    ret=""
    if with_edit_links
      ret<<"\n<div class=\"relatedLinks\">"
    end
    imgs="\n<div class=\"imageLeftCol\">"
   
    attachments=Attachment.find_all_by_page_id_and_language_code_and_enabled(page.id,Locale.language.code,true,:order=>'position')
    ulprinted=false
    attachments.each do |attachment|
      if attachment.can_be_viewed(session[:current_user_roles])
   
        if attachment.show_what=="text" 
               if !ulprinted
                  ret<<"\n<ul>"
                  ulprinted=true
                end
           if hide_dots || true
              ret<<"\n<li style=\"list-style: none;background-image:none;\">"
            else
              ret<<"\n<li>"
            end
          if with_edit_links
            ret<<display_attachment(attachment,false,false)
          else
            ret<<display_attachment(attachment,false,true,tinymce)
          end
          ret<<"\n\t</li>"
        else
          imgs<<display_attachment(attachment,false,false)
        end
      end
    end

    if logged_in? && current_user.is_editor? && with_edit_links
      ret<<"<li>"+link_to(image_tag(CMS_ICONS['pencil'],:border=>'0')+"Edit attachments".t,page_attachments_path(page)) +"</li>"
    end
     if ulprinted
        ret<<"\n</ul>"
    end
    imgs<<"\n</div>"
    if with_edit_links
      ret<<"</div>"+imgs
    end
    return ret
  end

end