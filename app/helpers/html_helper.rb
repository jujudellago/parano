module HtmlHelper
  def nicebox(title,body,width="120",cssclass="")
    ret=""
    ret << nicebox_title(title,width,cssclass)
    ret << body
    ret << nicebox_end
    return ret
  end

  def nicebox_title(title,width="120",cssclass="",hide=false)
    divid=title.gsub(/\s+/, '_').gsub(/[^a-zA-Z0-9_]+/, '')
    css=cssclass.blank? ? "" : "class=#{cssclass}"
    ret=""
    stle=""
    ret << "<div class=\"nice_box_#{width}\" ><div class=\"nb_inner\">"
    unless title.blank?
      ret << "<h4 #{css}>"
      displayed_title=""
      title_array=title.split
      i=0
      title_array.each do |t|
        if (i==0)
          displayed_title << "<span>"+t+" </span>"
        else
          displayed_title << t+" "
        end
        i+=1
      end
      #ret << displayed_title
      # ret << link_to_function( displayed_title, "$('"+divid+"').toggle()")
      # 
      if hide
        ret << link_to_function(displayed_title) do |page|   page.visual_effect(:toggle_blind, divid, {:duration=>0.5})  end
          stle= " style=\"display:none\""
        else
          ret << displayed_title
          stle=""
        end
        ret <<"</h4>"
      else
        ret<<"<div class=\"nice_box_sep\"></div>"
      end
      ret<< "<div id=\""+divid+"\" "+stle+">"
      return ret
    end
    def nicebox_end
      ret=""
      ret << %(
      </div></div></div>
      )
      return ret
    end


    def nicebox_title_remote(title,width="120",cssclass="")
      divid="user_context_menu"
      css=cssclass.blank? ? "" : "class=#{cssclass}"
      ret=""
      stle=""
      ret << "<div class=\"nice_box_#{width}\" ><div class=\"nb_inner\">"
      unless title.blank?
        ret << "<h4 #{css}>"
        displayed_title=""
        title_array=title.split
        i=0
        title_array.each do |t|
          if (i==0)
            displayed_title << "<span>"+t+" </span>"
          else
            displayed_title << t+" "
          end
          i+=1
        end
        ret << link_to_remote(displayed_title,:url=>menu_users_url,:method=>:get ) 
        stle= " style=\"display:none\""
        ret <<"</h4>"
      else
        ret<<"<div class=\"nice_box_sep\"></div>"
      end
      ret<< "<div id=\""+divid+"\" "+stle+">"
      return ret
    end

    def list_artists(objects)
      ret=""
      if objects.artists.size>0
        ret=content_tag("strong","Artists".t)
        ret<<"<ul>"
        objects.artists.each do |artist|
          ret<<content_tag("li",link_to(artist.name,admin_artist_path(artist)))
        end
        ret<<"</ul>"
      end
      return ret
    end
    def edit_button(link)
       link_to(image_tag(CMS_ICONS['edit'], :alt=>'edit'.t),  link )
    end
    def show_button(link)
      link_to(image_tag(CMS_ICONS['visible'], :alt=>'show'.t),  link)
    end
    def destroy_button(link, remote=false,label="item")
      if remote
        link_to_remote(image_tag(CMS_ICONS['delete'], :alt=>"Destroy".t), :url => link,	  :confirm => "Are you sure you wish to delete this #{label}?".t, :method => :delete)
      else
        link_to(image_tag(CMS_ICONS['delete'], :alt=>"Destroy".t), link, :confirm => 'Are you sure?', :method => :delete)
      end
    end
    
    def add_button(link)
      link_to_remote(image_tag(CMS_ICONS['edit_add'], :alt=>'add'.t), :url =>  link,:method=>:put)
    end
    def remove_button(link)
      link_to_remote(image_tag(CMS_ICONS['edit_remove'], :alt=>'add'.t), :url =>  link,:method=>:put)
    end


    def created_updated(object)
      ret=""
      unless object.created_at.nil?
        ret<<content_tag("strong", "created:")
        ret<<object.created_at.to_s(:db)
        ret<<"<br>"
        unless object.creator.nil?
          ret<<content_tag("strong", " by:")
          ret<<object.creator.display_name
        end
      end
      ret<<"<div class=\"thin_sep\"></div>"
      unless object.updated_at.nil?
        #ret<<"<br />"
        ret<<content_tag("strong", "updated:")
        ret<<object.updated_at.to_s(:db)
        ret<<"<br>"
        unless object.updater.nil?
          ret<<content_tag("strong", " by:")
          ret<<object.updater.display_name
        end
      end
      if object.has_attribute?('published_at')
        ret<<"<div class=\"thin_sep\"></div>"
         ret<<content_tag("strong", "published:")
        ret<<object.published_at.to_s(:db)
      end
      
      
      return content_tag("span",ret, :class=>'small_info')
    end
    
     def created_updated_activated(object)
        ret=""
        cpup=""
        cpup<<created_updated(object)
        ret<<"<div class=\"thin_sep\"></div>"
        unless object.activated_at.nil?
            #ret<<"<br />"
            ret<<content_tag("strong", "activated:")
            ret<<object.updated_at.to_s(:db)
            
       else
         ret<<content_tag("strong", "activated:")
         ret<<"Not yet!"

       end
       
       return cpup+content_tag("span",ret, :class=>'small_info')
    end
 

    # def sub_box_title(header="")
    #     ret=""
    #     ret << %(
    #     <div class="sub_div">
    #     <div class="sub_div_header">#{header}</div>
    #     <div class="sub_div_content" #{divid}>
    #     )
    #     return ret  
    #   end
    # 
    #   def sub_box_end
    #     ret=""
    #     ret << %(
    #     </div>
    #     </div>
    #     )
    #     return ret
    #   end

    def full_box(header="",divid=nil,icon=nil,&block)
      h=Htmlbox.new
      h.all_width("_all")
      h.set_icon_img(icon) unless icon.nil?
      h.set_header(header)
      divid=url_encode(header) if  divid.nil?
      h.set_div_id(divid) 
      h.set_loader_id(divid)
      concat(h.sub_box_title,block.binding)
      yield
      concat(h.sub_box_end,block.binding)
    end



    def sub_box(header="",divid=nil,icon=nil,&block)
      h=Htmlbox.new
      h.set_icon_img(icon) unless icon.nil?
      h.set_header(header)
      divid=url_encode(header) if  divid.nil?
      h.set_div_id(divid) 
      h.set_loader_id(divid)
      concat(h.sub_box_title,block.binding)
      yield
      concat(h.sub_box_end,block.binding)
    end

    def news_box(catid)
      ret=""
      cat=Category.find(catid) 
      h=Htmlbox.new
      h.set_header("#{"Latest".t}  #{cat.name}")
      h.set_div_id("art_div_#{cat.id}")
      h.set_loader_id(cat.id)
      h.set_link(link_to("#{"View more".t} #{cat.name}",category_articles_path(catid)))
      #h.set_footer("toto")
      h.set_wait_loading_message("Loading".t)
      ret<<h.sub_box_title
      ret<<h.sub_box_end
      #@dynaujs<<"getRssUpdater("/#{session[:locale]}/categories/#{cat.id}/articles/latest","art_div_#{cat.id}',10)"
      ret<<javascript_tag("getRssUpdater(\"/#{session[:locale]}/categories/#{cat.id}/articles/latest\",\"art_div_#{cat.id}\",\"#{cat.id}\");") 
      return ret
    end


    def artist_reports_box(artist_id)
      ret=""
      art=Artist.find(artist_id) 
      h=Htmlbox.new
      h.set_icon_img("6d")
      h.set_header("#{"Reports for".t}  #{art.name}")
      h.set_div_id("art_div_#{art.id}")
      h.set_loader_id(art.id)
      h.set_wait_loading_message("Loading".t)
      ret<<h.sub_box_title
      ret<<h.sub_box_end
      ret<<javascript_tag("getRssUpdater(\"/#{session[:locale]}/artists/#{art.slug}/articles/reports\",\"art_div_#{art.id}\",\"#{art.id}\")") 
      return ret
    end


    def artist_rating_box(artist_id)
      ret=""
      art=Artist.find(artist_id) 
      h=Htmlbox.new
      h.set_icon_img("6d")
      h.set_header("#{"Rating for".t}  #{art.name}")
      h.set_div_id("rat_div_#{art.id}")
      h.set_loader_id(art.id)
      h.set_wait_loading_message("Loading".t)
      ret<<h.sub_box_title
      ret<<h.sub_box_end
      ret<<javascript_tag("getRssUpdater(\"/#{session[:locale]}/artists/#{art.slug}/rating\",\"rat_div_#{art.id}\",\"#{art.id}\")") 
      return ret
    end
    def festival_reports_box(festival)
        ret=""

        h=Htmlbox.new
        h.set_icon_img("6d")
        h.set_header("#{"Reports in".t}  #{festival.name}")
        h.set_div_id("art_div_#{festival.id}")
        h.set_loader_id(festival.id)
        # h.set_link(link_to("View more #{cat.name}",category_articles_path(catid)))
        #h.set_footer("toto")
        h.set_wait_loading_message("Loading".t)
        ret<<h.sub_box_title
        ret<<h.sub_box_end
        #fr/locations/156/articles/reports
        #@dynaujs<<"getRssUpdater("/#{session[:locale]}/categories/#{cat.id}/articles/latest","art_div_#{cat.id}',10)"
        ret<<javascript_tag("getRssUpdater(\"/#{session[:locale]}/festivals/#{festival.slug}/articles/reports\",\"art_div_#{festival.id}\",\"#{festival.id}\");") 
        return ret
    end


    def edition_reports_box(festival,edition)
      ret=""

      h=Htmlbox.new
      h.set_icon_img("6d")
      h.set_header("#{"Reports in".t}  #{edition.year_for_param}")
      h.set_div_id("art_div_#{edition.id}")
      h.set_loader_id(edition.id)
      # h.set_link(link_to("View more #{cat.name}",category_articles_path(catid)))
      #h.set_footer("toto")
      h.set_wait_loading_message("Loading".t)
      ret<<h.sub_box_title
      ret<<h.sub_box_end
      #fr/locations/156/articles/reports
      #@dynaujs<<"getRssUpdater("/#{session[:locale]}/categories/#{cat.id}/articles/latest","art_div_#{cat.id}',10)"
      ret<<javascript_tag("getRssUpdater(\"/#{session[:locale]}/festivals/#{festival.slug}/editions/#{edition.slug}/articles/reports\",\"art_div_#{edition.id}\",\"#{edition.id}\");") 
      return ret
    end
    #No route matches "/fr/festivals/montreux-jazz-festival/editions/montreux-jazz-festival-2004/articles/reports" with {:method=>:get}




    def location_reports_box(loc)
      ret=""

      h=Htmlbox.new
      h.set_icon_img("6d")
      h.set_header("#{"Reports in".t}  #{loc.name}")
      h.set_div_id("art_div_#{loc.id}")
      h.set_loader_id(loc.id)
      # h.set_link(link_to("View more #{cat.name}",category_articles_path(catid)))
      #h.set_footer("toto")
      h.set_wait_loading_message("Loading".t)
      ret<<h.sub_box_title
      ret<<h.sub_box_end
      #fr/locations/156/articles/reports
      #@dynaujs<<"getRssUpdater("/#{session[:locale]}/categories/#{cat.id}/articles/latest","art_div_#{cat.id}',10)"
      ret<<javascript_tag("getRssUpdater(\"/#{session[:locale]}/locations/#{loc.slug}/articles/reports\",\"art_div_#{loc.id}\",\"#{loc.id}\");") 
      return ret
    end
    def location_events_box(loc)
      ret=""
      h=Htmlbox.new
      h.set_icon_img("6d")
      h.set_header("#{"Next events in".t}  #{loc.name}")
      h.set_div_id("loc_div_event_#{loc.id}")
      h.set_loader_id("event_"+loc.id.to_s)
      h.set_wait_loading_message("Loading".t)
      ret<<h.sub_box_title
      ret<<h.sub_box_end
      ret<<javascript_tag("getRssUpdater(\"/#{session[:locale]}/locations/#{loc.slug}/events/next\",\"loc_div_event_#{loc.id}\",\"event_#{loc.id}\")") 
      return ret
    end
    
    def edition_events_box(edition)
       ret=""
        h=Htmlbox.new
        h.set_icon_img("6d")
        h.set_header("#{"Next events in".t}  #{loc.name}")
        h.set_div_id("loc_div_event_#{loc.id}")
        h.set_loader_id("event_"+loc.id.to_s)
        h.set_wait_loading_message("Loading".t)
        ret<<h.sub_box_title
        ret<<h.sub_box_end
        ret<<javascript_tag("getRssUpdater(\"/#{session[:locale]}/locations/#{loc.slug}/events/next\",\"loc_div_event_#{loc.id}\",\"event_#{loc.id}\")") 
        return ret
    end
    
    
    
    
    def artist_events_box(art)
      ret=""
      h=Htmlbox.new
      h.set_icon_img("6d")
      h.set_header("#{"Next events for".t}  #{art.name}")
      h.set_div_id("art_div_event_#{art.id}")
      h.set_loader_id("event_"+art.id.to_s)
      h.set_wait_loading_message("Loading".t)
      ret<<h.sub_box_title
      ret<<h.sub_box_end
      ret<<javascript_tag("getRssUpdater(\"/#{session[:locale]}/artists/#{art.slug}/events/next\",\"art_div_event_#{art.id}\",\"event_#{art.id}\")") 
      return ret
    end
    

    def web_box(name="",website="")
      if website.blank? 
        return ""
      end
      ret=""
      h=Htmlbox.new
      h.set_icon_img("6d")
      clean_name=name.downcase.gsub(/\s+/, '_').gsub(/[^a-zA-Z0-9_]+/, '')
      h.set_div_id("web_"+clean_name)
      h.set_header(website)
      ret<<h.sub_box_title
      unless website.blank?
        wicon=webicon(website,{:width=>'184',:height=>'140',:align=>'right'})
        ret<<wicon
        ret<<"<ul>"
        ret<<content_tag("li",link_to_lightview("preview".t,website, {:iframe=>true,:title=>name,:caption=>website,:fullscreen=>true}))
        ret<<content_tag("li",link_to("visit".t,website,:target=>'_blank'))
        ret<<"</ul>"
      end
      ret<<h.sub_box_end
      return ret
    end


    def myspace_box(name="",myspace="")
      if myspace.blank?
        return ""
      end
      ret=""
      h=Htmlbox.new
      h.set_icon_img("myspace")
      h.set_header(name+" "+"on myspace".t)
      clean_name=name.downcase.gsub(/\s+/, '_').gsub(/[^a-zA-Z0-9_]+/, '')
      h.set_div_id("myspace_"+clean_name)
      ret<<h.sub_box_title
      unless myspace.blank?
        fullmyspace="http://www.myspace.com/"+myspace
        micon=webicon("http://www.myspace.com/"+myspace,{:width=>'184',:height=>'140',:align=>'right'})
        ret<<micon
        ret<<"<ul>"
        ret<<content_tag("li",link_to_lightview("preview".t,fullmyspace, {:iframe=>true,:title=>name+" on myspace".t,:caption=>fullmyspace,:fullscreen=>true}))
        ret<<content_tag("li",link_to("visit".t,fullmyspace,:target=>'_blank'))
        ret<<"</ul>"
      end
      ret<<h.sub_box_end
      return ret
    end
    def basic_contact_box(object,admin=false)
      ret=""
      h=Htmlbox.new
      h.set_icon_img("6d")
      something=false
      label="Contact for".t+" "+object.display_name
      clean_name=label.downcase.gsub(/\s+/, '_').gsub(/[^a-zA-Z0-9_]+/, '')
      h.set_div_id("contact_"+clean_name)
      h.set_header(label)
      ret<<h.sub_box_title

      if (!object.phone.blank?) || admin
        ret<<banner_item("Phone".t,object.phone)
        something=true
      end
      if (!object.mobile_phone.blank?)  || admin
        ret<<banner_item("Mobile".t,object.mobile_phone)
        something=true
      end    
      unless object.email.blank?
        ret<<banner_item("Email".t,mail_to(object.email,"contact #{object.display_name}"))
        something=true
      end
      ret<<h.sub_box_end
      return ret if something
    end





    def contact_box(user,admin=false)
      ret=""
      h=Htmlbox.new
      h.set_icon_img("6d")
      label="Contact".t+" "+user.display_name
      clean_name=label.downcase.gsub(/\s+/, '_').gsub(/[^a-zA-Z0-9_]+/, '')
      h.set_div_id("contact_"+clean_name)
      h.set_header(label)
      ret<<h.sub_box_title

      if (!user.detail.phone.blank?) && admin
        ret<<banner_item("Phone".t,user.detail.phone)
      end
      if (!user.detail.mobile_phone.blank?) && admin
        ret<<banner_item("Mobile".t,user.detail.mobile_phone)
      end    
      unless user.email.blank?
        ret<<banner_item("Email".t,mail_to(user.email,"contact #{@user.display_name}"))
      end
      unless user.detail.skype_username.blank?
        ret<<banner_item("Email".t,getSkypeButton(@user.detail.skype_username))
      end
      unless user.detail.google_username.blank?
        ret<<content_tag("p",content_tag("b","Google".t)+": "+mail_to(user.detail.google_username+"@google.com",user.detail.google_username))
      end
      unless user.detail.msn_username.blank?
        ret<<content_tag("p",content_tag("b","Msn".t)+": "+mail_to(user.detail.msn_username,"msn"))
      end
      unless user.detail.yahoo_username.blank?
        ret<<content_tag("p",content_tag("b","Yahoo".t)+": "+mail_to(user.detail.yahoo_username+"@yahoo.com",user.detail.yahoo_username))
      end
      ret<<h.sub_box_end
      return ret
    end


    def lastfm_similar_box(encoded_name,artist)
      ret=""
      img="<img src=\"/images/icons/logos/last-fm_16.gif\" align=\"right\" class=\"fl_right\">"
      clean_name=artist.downcase.gsub(/\s+/, '_').gsub(/[^a-zA-Z0-9_]+/, '')
      url="http://www.lastfm.fr/music/#{encoded_name}"
      caption="lastFm page for ".t+artist
      artist_url="http://ws.audioscrobbler.com/1.0/artist/#{encoded_name}/similar.xml&index=1"
      feed_url = "http://ws.audioscrobbler.com/1.0/artist/#{encoded_name}/similar.xml"
      tracks_url="http://ws.audioscrobbler.com/1.0/artist/#{encoded_name}/toptracks.xml"
      tags_url="http://ws.audioscrobbler.com/1.0/artist/#{encoded_name}/toptags.xml"
      h=Htmlbox.new
      h.set_header("#{link_to_lightview(img,url,{:iframe=>true,:fullscreen=>true})} #{"Artist on lastFm".t} ")
      h.set_div_id("art_div_#{clean_name}")
      h.add_topnav_elem({:label=>"Artist",:link=>artist_url})
      h.add_topnav_elem({:label=>"Similar Artists",:link=>feed_url})
      h.add_topnav_elem({:label=>"Top Tracks",:link=>tracks_url})
      h.add_topnav_elem({:label=>"Top Tags",:link=>tags_url})
      h.set_loader_id(clean_name)
      h.set_wait_loading_message("Loading".t)
      ret<<h.sub_box_title
      #ret<<" Loading".t+" "+image_tag('spinner.gif') 

      ret<<h.sub_box_end
      #@dynaujs<<"getRssUpdater("/#{session[:locale]}/categories/#{cat.id}/articles/latest","art_div_#{cat.id}',10)"
      ret<<javascript_tag("getRssUpdater(\"/rss_proxy?rss_url=#{feed_url}&index=1\",\"art_div_#{clean_name}\",\"20\")") 
      return ret
    end





    def amazon_box(encoded_name,artist)
      ret=""
      clean_name="amaz_"+artist.downcase.gsub(/\s+/, '_').gsub(/[^a-zA-Z0-9_]+/, '')
      caption="Amazon albums for ".t+artist
      feed_url = "http://webservices.amazon.com/onca/xml?Service=AWSECommerceService&Operation=ItemSearch&SearchIndex=Music&ResponseGroup=Small,Images,Tracks&Artist=#{encoded_name}"
      h=Htmlbox.new
      #ItemPage=2
      h.add_topnav_elem({:label=>".: 1 :. ",:link=>feed_url+"&ItemPage=1"})
      h.add_topnav_elem({:label=>".: 2 :. ",:link=>feed_url+"&ItemPage=2"})
      h.add_topnav_elem({:label=>".: 3 :. ",:link=>feed_url+"&ItemPage=3"})
      h.add_topnav_elem({:label=>".: 4 :. ",:link=>feed_url+"&ItemPage=4"})
      h.set_icon_img("amazon")
      h.set_header(caption)
      h.set_div_id("art_div_#{clean_name}")
      h.set_loader_id(clean_name)
      h.set_wait_loading_message("Loading".t)
      ret<<h.sub_box_title
      #ret<<" Loading".t+" "+image_tag('spinner.gif') 

      ret<<h.sub_box_end
      #@dynaujs<<"getRssUpdater("/#{session[:locale]}/categories/#{cat.id}/articles/latest","art_div_#{cat.id}',10)"
      ret<<javascript_tag("getRssUpdater(\"/rss_proxy?rss_url=#{feed_url}\",\"art_div_#{clean_name}\",\"20\")") 
      return ret
    end




    # def sub_box(title="",divid=nil,&block)
    #     set_header(title)
    #     set_div_id(divid) unless divid.nil?
    #     concat (sub_box_title,block.binding)
    #     yield
    #     concat (sub_box_end,block.binding)
    #  end


    def two_columns_table_start
      ret=""
      ret << %(
      <table id="magazine_content" style="width: 100%;">
      <tbody>
      <tr>
      <td id="column-0" class="two_columns" style="width: 50%; position: relative;"  valign="top">
      )
      return ret
    end
    def two_columns_table_sep
      ret=""
      ret << %(
      </td>
      <td id="column-1" class="two_columns" style="width: 50%; position: relative;"  valign="top">
      )
      return ret
    end


    def two_columns_table_full_start
      ret=""
      ret << %(
      <table id="magazine_content" style="width: 100%;">
      <tbody>
      <tr valign="top">
      <td colspan="2">
      )
      return ret
    end
    def two_columns_table_full_end
      ret=""
      ret << %(
      </td>
      </tr>
      <tr>
      <td id="column-1" class="two_columns" style="width: 50%; position: relative;" valign="top">
      )
      return ret
    end

    def two_columns_table_sep_full
      ret=""
      ret << %(
      </td></tr><tr><td colspan="2">
      )
      return ret
    end



    def two_columns_table_end
      ret=""
      ret << %(
      </td>
      </tr>
      </tbody>
      </table>
      )
      return ret
    end



    def banner_item(label,content)
      return if content.blank?
      ret=""
      ret << %(
      <p><strong>#{label}</strong>: #{content}</p>
      )
      return ret
    end

    def webicon(url,options={})
      width=options[:width].nil? ? "92" : options[:width]
      height=options[:height].nil? ? "70" : options[:height]
      align=options[:align].nil? ? "right" : options[:align]
      return "<img src=\"http://images.websnapr.com/?url=#{url}&size=#{height}x#{width}\" border=\"0\" width=\"#{width}\" height=\"#{height}\" align=\"#{align}\" alt=\"#{url}\" class=\"webicon\">"
    end
    def lightwindow_web_ajax(url)
      return lightwindow_web(url,url,caption="",url)
    end

    def lightwindow_web(url,title="",caption="",linklabel="",parse=true)
      # title= title.blank? ? url : title
      #    caption = caption.blank? ? url : caption
      url=escape_javascript(url)
      title=escape_javascript(title)
      caption=escape_javascript(caption)
      linklabel=escape_javascript(linklabel)  if parse
      myid=randomstring(6)
      unless linklabel.blank?
        #return "<a href=\""+url+"\" class=\"lightwindow page-options\" title=\""+title+"\"  caption=\""+caption+"\" >"+linklabel+"</a>"
        rr= "<a href=\""+url+"\" title=\""+caption+"\" id=\"#{myid}\">"+linklabel+"</a>"  
        rr=rr+javascript_tag("var myLightWindow_#{myid}=new lightwindow();\n myLightWindow_#{myid}.createWindow('#{myid}');")
        return rr
      else
        return url+" <a href=\""+url+"\" class=\"lightwindow page-options\" title=\""+title+"\"  caption=\""+caption+"\" >"+"Preview".t+"</a>"
      end
    end

    def lightwindow_simple(url,label)
      return " <a href=\""+url+"\" class=\"lightwindow page-options\" title=\""+label+"\"  caption=\""+label+"\" >"+label+"</a>"
    end
    def link_to_lw(label,url,options={})
      sizeoptions=""
      rr=""
      if options[:width] && options[:height]
        sizeoptions="params=\"lightwindow_width=#{options[:width]},lightwindow_height=#{options[:height]},lightwindow_loading_animation=false\" " 
      end    
      if options[:unique_id]
        myid=randomstring(6)
        rr<<" <a href=\"#{url}\" #{sizeoptions}  title=\"#{options[:title]}\" id=\"#{myid}\"  caption=\"#{options[:caption]}\" >#{label}</a>"
        rr<<javascript_tag("var myLightWindow_#{myid}=new lightwindow();\n myLightWindow_#{myid}.createWindow('#{myid}');")
      else
        rr= " <a href=\"#{url}\" class=\"lightwindow page-options\" #{sizeoptions}  title=\"#{options[:title]}\"  caption=\"#{options[:caption]}\" >#{label}</a>"
      end
      return rr
    end

    def link_to_lightview(label,url,options={})
      rr=""
      rel=""
      sizeoptions=""
      title=""
      if options[:gallery]
        rel=" rel='gallery[#{options[:gallery]}]' "
      end
      if options[:iframe]
        rel=" rel='iframe' "
        if options[:width] && options[:height]
          sizeoptions="width: #{options[:width]}, height: #{options[:height]} " 
        elsif options[:fullscreen]
          sizeoptions="fullscreen: true "
        end    
      end
      title="title='#{options[:title]} :: #{options[:caption]} :: #{sizeoptions}'"
      rr<<"<a href='#{url}' class='lightview' #{rel} #{title}>#{label}</a>"
      return rr
    end

    # <a href='http://www.yahoo.com' rel='iframe' title='Yahoo :: A caption :: width: 800, height: 600'
    #  class='lightview' >Yahoo</a>
     def light_photo(photo,reflect=true)
        displayed=display_photo(photo,reflect)
        return link_to_lightview(displayed,  photo.public_filename, {:gallery=>true,:title=>photo.name,:caption=>photo.legend}) 
      end

      def display_photo(photo,reflect=true)
        if reflect 
          return image_tag(photo.public_filename(:thumb),:class=>'reflect ropacity25',:alt=>photo.name,:border=>'0',:onmouseover=>"Reflection.add(this, { opacity: 3/4 });", :onmouseout=>"Reflection.add(this, { opacity: 1/4 });")  
        else
          return image_tag(photo.public_filename(:thumb),:alt=>photo.name,:title=>photo.name,:legend=>photo.legend,:border=>'0')  
        end
      end

  end


  class Htmlbox


    def hello
      return "hello world"
    end

    @@header=""
    @@headerdivname=""
    @@divid=""
    @@link=""
    @@footer=""
    @@loaderid=""
    @@topnav=[]
    @@rssupdatelinkname=""
    @@icon_image=""
    @@wait_loading_message=nil
    def initialize
      @@header=""
      @@headerdivname=""
      @@divid=""
      @@link=""
      @@footer=""
      @@loaderid=""
      @@rssupdatelinkname=""
      @@topnav=[]
      @@icon_image=""
      @@wait_loading_message=nil
      @@width_class=""
    end

    def set_icon_img(s)
      @@icon_image="<img src=\"/images/icons/logos/#{s}_16.gif\" align=\"right\" class=\"fl_right\">"

    end
    def set_wait_loading_message(s)
      @@wait_loading_message=s
    end

    def set_header(s)
      @@header=s
    end
    def set_loader_id(s)
      @@loaderid=s
    end
    def all_width(s)
      @@width_class=s
    end

    def set_div_id(s)
      @@divid=" id=\"#{s}\""
      @@headerdivname=" name=\"arr_#{s}\""
      @@rssupdatelinkname=" name=\"rss_#{s}\""
    end

    def set_footer(s)
      @@footer="<div class=\"sub_div_footer\">#{s}</div>"
    end

    def set_link(s)
      @@link="<span class=\"sub_div_link\"><ul><li>#{s}</li></ul></span>"
    end

    def add_topnav_elem(s)
      @@topnav<<s
    end

    def sub_box_title
      ret=""
      ret << %(
      <div class="main_div#{@@width_class}">	
      <div class="sub_div">
      <div class="sub_div_header"><a href=\"#\" ><img src=\"/images/icons/arrow1_down.gif\" #{@@headerdivname} border=\"0\" class=\"arrow\"></a>#{@@link} #{@@icon_image} #{@@header} </div>
      )
      if @@topnav.size>0
        ret<<"<ul class=\"rss_nav_rssfeed\" id=\"rss_nav_ul_#{@@loaderid}\">"
        @@topnav.each_with_index do |elem,i|
          linkclass= (i==0)? "class=\"a_selected\"" : ""
          ret << %(
          <li><a href="#{elem[:link]}" #{@@rssupdatelinkname} #{linkclass}>#{elem[:label]}</a></li>
          )
        end
        ret<<"</ul>"       
      end
      ret << %(
      <div id="html_box_loader_#{@@loaderid}" class="transparent_message_html_box" style="display:none" > Loading <img src="/images/spinner.gif"></div>
      <div class="sub_div_content" #{@@divid}>
      )
      unless @@wait_loading_message.nil?
        ret << %(
        <div  class="wait_transparent_message_html_box">#{@@wait_loading_message}<img src="/images/spinner.gif"></div>
        )
      end

      return ret  
    end



    def sub_box_end
      ret=""
      ret << %(
      </div>

      </div>#{@@footer}
      </div>
      )
      return ret
    end



    # def to_s
    #   ret=""
    #    ret<<sub_box_title
    #    ret<<@@content
    #    ret<<sub_box_end
    #    return ret
    # end

    # def sub_box(header="",content="")
    #   ret=""
    #   ret <<sub_box_title(header)
    #   ret <<content
    #   ret <<sub_box_end
    #   return ret
    # end

  end