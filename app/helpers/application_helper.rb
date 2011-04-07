module ApplicationHelper
  def base_language_only
    yield if Locale.base?
  end

  def not_base_language
    yield unless Locale.base?
  end
  def country_icon(code,color=false)
    path="/images/flags/"+code+".gif"
    path="/images/flags/color/"+code+".gif" if color
    image_tag(path)
  end
  def getFile_type_icon(filename)
    if filename==nil
      return ""
    else
      if filename.ends_with?(".pdf")
        img="pdf"
      elsif filename.ends_with?(".doc")
        img="doc"
      elsif filename.ends_with?(".xls")||filename.ends_with?(".xlt")
        img="xls"
      elsif filename.ends_with?(".avi")||filename.ends_with?(".mpeg")||filename.ends_with?(".mpg")||filename.ends_with?(".divx")
        img="video"
      elsif filename.ends_with?(".zip")||filename.ends_with?(".rar")||filename.ends_with?(".sit")||filename.ends_with?(".tar")
        img="zip"
      elsif filename.ends_with?(".jpg")||filename.ends_with?(".jpeg")||filename.ends_with?(".png")||filename.ends_with?(".gif")||filename.ends_with?(".tiff")
        img="jpeg"
      elsif filename.starts_with?("http://")
        img="web"
      elsif filename.starts_with?("mailto:")
        img="email"
      else
        img="empty"
      end
      return image_tag("/images/icons/mimetypes/"+img+".gif",:border=>'0')
    end
  end

  def article_icon(article, options = {})
    img='no-image-50.jpg'
    if article.icon
      img=article.icon.public_filename(:tiny)
    end
    return image_tag(img,options)
  end
  def article_icon_for_list(article, options = {})
    img='empty_thumb.gif'
    if article.icon
      return image_tag (article.icon.public_filename(:thumb), options)
    else  
      return ""
    end
    #return image_tag(img, options)
  end
  
  def link_to_print(url)
    image_tag('/images/icons/print.gif', :alt=>"Print this page", :id=>'print_link',:title=>"Print this page",:align=>'right' ,  :onclick=>"window.open('#{url}', 'print', 'width=550,height=600,toolbar=no,scrollbars=yes,resizable=yes')")
  end
 def link_to_comment(subject,url,force_right=true)
  
  #  TODO fix this ugly duplication with a params.merge !!
   if force_right
     mail_to(COMMENTEMAIL, image_tag('/images/icons/comment.gif', :alt=>"Print this page",:border=>0, :id=>'comment_link',:title=>"Comment this page",:align=>'right'),
    :subject =>"Comment about"+" \""+subject+"\"",:body=>url )
  else
    mail_to(COMMENTEMAIL, image_tag('/images/icons/comment.gif', :alt=>"Print this page",:border=>0, :id=>'comment_link',:title=>"Comment this page"), :subject =>"Comment about"+" \""+subject+"\"",:body=>url )
  end
 end

  

  
  
 def display_attachment(attachment,disable_links=false,thumb=true,tinymce=false)
   displayed=""
   linked=""

   if attachment.show_what=="text" 
     displayed=attachment.name 
   else

     unless attachment.icon.nil? 
       if thumb
         displayed=image_tag(attachment.icon.public_filename(:thumb),:class=>'icon',:alt=>attachment.legend,:title=>attachment.legend,:border=>'0') 

       else
         displayed=image_tag(attachment.icon.public_filename(:banner),:class=>'banner',:alt=>attachment.legend,:title=>attachment.legend,:border=>'0') 
       end
       #displayed<<content_tag("span",attachment.legend,:class=>'legend') unless attachment.icon.nil?
     end

   end 
   if disable_links
     return displayed
   end


   if attachment.linktype=="url"
     displayed=getFile_type_icon(attachment.url)+displayed  if attachment.show_what=="text" 
     if tinymce
       linked=link_to_function(displayed,"window.opener.document.getElementById('href').value='#{attachment.url}';window.close()") 
     else  
       linked=link_to(displayed,attachment.url,:target=>'_blank',:title=>attachment.legend)
     end

     if attachment.url.blank?
       linked=displayed
     end


   elsif attachment.linktype=="image" &&(!attachment.icon.nil?)
     linked=lightbox_link_to(displayed,  attachment.icon.public_filename ,  :rel => "lightbox[myalbum]" ,:title=>attachment.legend) 
     
   elsif attachment.linktype=="nothing"
     linked=displayed
     if attachment.show_what=="text" 
       if !thumb
         linked="<h6>"+displayed+"</h6>"
       else
         linked="<strong>"+displayed+"</strong>"
       end
     end

   else 
     if attachment.show_what=="text" 
       displayed=getFile_type_icon(attachment.attachedfile.public_filename)+displayed  unless attachment.attachedfile.nil?
     end
     if tinymce
       linked=link_to_function(displayed,"window.opener.document.getElementById('href').value='#{attachment.attachedfile.public_filename}';window.close()") unless attachment.attachedfile.nil? 
     else
       linked=link_to(displayed,attachment.attachedfile.public_filename,:target=>'_blank',:title=>attachment.legend) unless attachment.attachedfile.nil? 
     end
   end 
   
   
   unless attachment.icon.nil? 
     linked<<content_tag("span",attachment.legend,:class=>'legend') 
   end
   
   return  linked

 end


end
