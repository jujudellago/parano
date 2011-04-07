module JujuHelper
 def ajax_spinner_for(id, spinner="spinner.gif")
    "<img src='/images/#{spinner}' style='display:none; vertical-align:middle;' id='#{id.to_s}_spinner'> "
  end
  def js_open
    '<script type="text/javascript">//<![CDATA[' + "\n"
  end
  
  def js_close
    "\n" + '//]]>' + "</script>"
  end

    def format_user_text(input)
      return if input.nil?
      RAILS_DEFAULT_LOGGER.error("\n JujuHelper format_user_text input.strip #{input.strip} !\n")
       output = "#{input.strip} "

       # do some formatting
       output.gsub!(/\r\n/, "\n")       # remove CRLFs
       output.gsub!(/^$\s*/m, "\n")     # remove blank lins
       output.gsub!(/\n{3,}/, "\n\n")   # replace \n\n\n... with \n\n
       output.gsub!(/\n\n/, '</p><p>')  # embed stuff in paragraphs
       output.gsub!(/\n/, '<br/>')      # nl2br
       output.gsub!(/<p/, "\n<p")      # nl2br
       #output.gsub!(/&lt;!\w*&gt/, '')
       #output.gsub!(/&lt;!--*--&gt;/, '')
       output.gsub!(/&lt;!--(.*?)--&gt;/, "") 
       output.gsub!(/<!--(.*?)-->/, "")      
       output.gsub!(/<table/, "<table cellspacing=\"0\" cellpadding=\"0\"  style=\"border-collapse: collapse\"")      
   #    output.gsub!(/class=\"MsoNormal\"/,'')
  #    output.gsub!(/(<!--.*?-->)/,'')
       #sanitize_fu output
        RAILS_DEFAULT_LOGGER.error("\n JujuHelper nApplication format_user_text output #{output} !\n")
       output
     end

   # Adapted from http://ideoplex.com/id/1138/sanitize-html-in-ruby
   def sanitize_fu(html, okTags = 'a href, b, br, p, i, em')
      return if html.nil?
     # no closing tag necessary for these
     soloTags = ["br","hr"]

     # Build hash of allowed tags with allowed attributes
     tags = okTags.downcase().split(',').collect!{ |s| s.split(' ') }
     allowed = Hash.new
     tags.each do |s|
       key = s.shift
       allowed[key] = s
     end

     # Analyze all <> elements
     stack = Array.new
     result = html.gsub( /(<.*?>)/m ) do | element |
       if element =~ /\A<\/(\w+)/ then
         # </tag>
         tag = $1.downcase
         if allowed.include?(tag) && stack.include?(tag) then
           # If allowed and on the stack
           # Then pop down the stack
           top = stack.pop
           out = "</#{top}>"
           until top == tag do
             top = stack.pop
             out << "</#{top}>"
           end
           out
         end
       elsif element =~ /\A<(\w+)\s*\/>/
         # <tag />
         tag = $1.downcase
         if allowed.include?(tag) then
           "<#{tag} />"
         end
       elsif element =~ /\A<(\w+)/ then
         # <tag ...>
         tag = $1.downcase
         if allowed.include?(tag) then
           if ! soloTags.include?(tag) then
             stack.push(tag)
           end
           if allowed[tag].length == 0 then
             # no allowed attributes
             "<#{tag}>"
           else
             # allowed attributes?
             out = "<#{tag}"
             while ( $' =~ /(\w+)=("[^"]+")/ )
               attr = $1.downcase
               valu = $2
               if allowed[tag].include?(attr) then
                 out << " #{attr}=#{valu}"
               end
             end
             out << ">"
           end
         end
       end
     end

     # eat up unmatched leading >
     while result.sub!(/\A([^<]*)>/m) { $1 } do end

     # eat up unmatched trailing <
     while result.sub!(/<([^>]*)\Z/m) { $1 } do end

     # clean up the stack
     if stack.length > 0 then
       result << "</#{stack.reverse.join('></')}>"
     end

     result
   end
  
  
  
   def use_tinymce(theme="advanced")


         if theme=="advanced"
         string = <<END_OF_STRING
         tinyMCE.init({
         	mode : "textareas",
         	editor_selector : "tiny_mce",
         	theme : "advanced",
         	language : "fr",
         	plugins : "inlinepopups,ts_advimage,advlink,emotions,iespell,zoom,searchreplace,fullscreen,visualchars,youtube,table,contextmenu",
         	theme_advanced_buttons1 : "undo,redo,removeformat,|,formatselect,|,bold,italic,underline,strikethrough,sub,sup,|,outdent,indent,bullist,numlist,hr",
         	theme_advanced_buttons2 : "backcolor,|,link,unlink,charmap,emotions,ts_image,youtube,iespell,|,search,replace,|,cleanup,code,fullscreen,help",
         	theme_advanced_buttons3 : "tablecontrols,|,hr,removeformat,visualaid,|,sub,sup",
         	theme_advanced_toolbar_location : "top",
         	theme_advanced_toolbar_align : "left",
         	theme_advanced_path_location : "bottom",
         	theme_advanced_blockformats : "p,h1,h2,h3,h4,blockquote",
         	gecko_spellcheck : true,
     	    relative_urls : false, 
         	extended_valid_elements : "a[name|href|target|title|onclick],img[class|src|style|border=0|alt|title|hspace|vspace|width|height|align|onmouseover|onmouseout|name],hr[class|width|size|noshade],span[class|align|style],font[]",
         	theme_advanced_resizing : true,
         	theme_advanced_resize_horizontal : false
         });
END_OF_STRING

 elsif theme=="basic"
     string = <<END_OF_STRING
     tinyMCE.init({
     	mode : "textareas",
     	editor_selector : "tiny_mce",
     	theme : "advanced",
     	language : "fr",
     	width : '520',
     	height: '280',
         theme_advanced_buttons1 : "bold,italic,underline,separator,strikethrough,justifyleft,justifycenter,justifyright, justifyfull,bullist,numlist,undo,redo,link,unlink",
       	theme_advanced_buttons2 : "",
       	theme_advanced_buttons3 : "",
       	theme_advanced_toolbar_location : "top",
       	theme_advanced_toolbar_align : "left",
       	theme_advanced_path_location : "bottom",
       	theme_advanced_blockformats : "p,h1,h2,h3,h4,blockquote",
       	gecko_spellcheck : true,
       	extended_valid_elements : "a[name|href|target|title|onclick],img[class|src|style|border=0|alt|title|hspace|vspace|width|height|align|onmouseover|onmouseout|name],hr[class|width|size|noshade],span[class|align|style]",
       	theme_advanced_resizing : true,
       	theme_advanced_resize_horizontal : false
     });
END_OF_STRING
 else
    string = <<END_OF_STRING
     tinyMCE.init({
     	mode : "textareas",
     	editor_selector : "tiny_mce",
     	theme : "simple",
     	plugins : "inlinepopups,ts_advimage,advlink,emotions,iespell,zoom,searchreplace,fullscreen,visualchars,youtube,table",
     	theme_advanced_buttons1 : "undo,redo,removeformat,|,formatselect,|,bold,italic,underline,strikethrough,sub,sup,|,outdent,indent,bullist,numlist,hr",
     	theme_advanced_buttons2 : "backcolor,|,link,unlink,charmap,emotions,ts_image,youtube,iespell,|,search,replace,|,cleanup,code,fullscreen,help",
     	theme_advanced_buttons3 : "tablecontrols,|,hr,removeformat,visualaid,|,sub,sup",
     	theme_advanced_toolbar_location : "top",
     	theme_advanced_toolbar_align : "left",
     	theme_advanced_path_location : "bottom",
     	theme_advanced_blockformats : "p,h1,h2,h3,h4,blockquote",
     	gecko_spellcheck : true,
     	extended_valid_elements : "a[name|href|target|title|onclick],img[class|src|style|border=0|alt|title|hspace|vspace|width|height|align|onmouseover|onmouseout|name],hr[class|width|size|noshade],span[class|align|style],font[]",
     	theme_advanced_resizing : true,
     	theme_advanced_resize_horizontal : false
     });
END_OF_STRING
 end

     js_open + string + js_close
   end
  
  def split_title(title)
    displayed_title=""
    unless title.blank?
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
    end
    return displayed_title
  end


  def JujuHelper.nil_if_blank(value)
    return value.blank? ? nil : value
  end

  def html_table(collection, headers, options = {}, &proc)
    options.reverse_merge!({
      :placeholder  => 'Nothing to display',
      :caption      => nil,
      :table_class => nil,
      :summary      => nil,
      :footer       => ''
      })
      placeholder_unless collection.any?, options[:placeholder] do
        summary = options[:summary] || "A list of #{collection.first.class.to_s.pluralize}"
        tblclass=" class=\""+options[:table_class]+"\"" if options[:table_class]
        output = "<table summary=\"#{summary}\" #{tblclass}>\n"
        output << content_tag('caption', options[:caption]) if options[:caption]
        output << "\t<caption>#{options[:caption]}</caption>\n" if options[:caption]
        output << content_tag('thead', content_tag('tr', headers.collect { |h| "\n\t" + content_tag('th', h) }))
        output << "<tfoot><tr>" + content_tag('th', options[:footer], :colspan => headers.size) + "</tr></tfoot>\n" if options[:footer]
        output << "<tbody>\n"
        concat(output, proc.binding)
        collection.each do |row|
          proc.call(row, cycle('odd', 'even'))
        end
        concat("</tbody>\n</table>\n", proc.binding)
      end
    end
    def placeholder(message = 'Nothing to display', options = {}, &proc)
      # set default options
      o = { :class => 'placeholder', :tag => 'p' }.merge(options)

      # wrap the results of the supplied block, or
      # just print out the message
      if proc
        t = o.delete(:tag)
        concat tag(t, o, true), proc.binding
        yield
        concat "</#{t}>", proc.binding
      else
        content_tag o.delete(:tag), message, o
      end
    end

    def placeholder_unless(condition, *args, &proc)
      condition ? proc.call : concat(placeholder(args), proc.binding)
    end
    def JujuHelper.clean_accents_for_urls(input)
      # I know it's ugly !!!!  these regexp are so damn complicated ! :(
      input= input.gsub(/è/, 'e')
      input= input.gsub(/é/, 'e')
      input= input.gsub(/ê/, 'e')

      input= input.gsub(/ý/, 'y')

      input= input.gsub(/î/, 'i')
      input= input.gsub(/ï/, 'i')

      input= input.gsub(/û/, 'u')
      input= input.gsub(/ü/, 'u')

      input= input.gsub(/ä/, 'a')
      input= input.gsub(/à/, 'a')

      input= input.gsub(/ò/, 'o')
      input= input.gsub(/ô/, 'o')
      return input
    end
    def flash_message_loop(options = {})
      html = ""
      ## Check some of common flash keys
      [:error, :notice, :info, :warning].each do |key|
        if flash[key]
          html = content_tag("div", content_tag("p", flash[key]), :id => "flash_message", :class => "flash_message_#{key.to_s}")
          flash.discard
          break
        end
      end    
      unless html.empty?
        html 
      end
    end
    def fieldset_legend(text)
      return "<fieldset><legend>#{text}</legend>"
    end
    def fieldset_end
      return "</fieldset>"
    end
    def upload_frame
      return "<iframe id='upload_frame' name='upload_frame' style='width:1px;height:1px;border:0px' src='about:blank'></iframe>"
    end
    def start_form_container
      return "<div id=\"pages_editor_container\">\n<div class=\"form-container\">"
    end
    def end_form_container
      return "</div>\</div>"
    end

    # build a structured list of archive items
    def self.archives_structure_linked(articles, archive_token="news")
      cy = 0
      cm = 0
      closed_y = true
      closed_m = true
      keep_month = ''
      keep_year = ''

      output = ''
      for p in articles
        if keep_year != p.display_date.year
          if cy != 0
            output << "\n</ul>"
            closed_y = true
            cy = 0
          end
          output << "\n<h4>#{p.display_date.year}</h4>\n\t<ul class=\"archive_news\">"
          closed_y = false
        end
        if keep_month != p.display_date.month
          if cm != 0
            #output << otc
            closed_m = true
            cm = 0
          end
          #output << "\n\t\t<li><a href=\"/#{Locale.language.code}/archives/#{archive_token}/#{p.display_date.strftime('%Y/%m')}\" title=\"#{p.display_date.loc('%B')}\">#{p.display_date.loc('%B')}</a></li>"
          output << "\n\t\t<li><a href=\"/fr/archives/#{archive_token}/#{p.display_date.strftime('%Y/%m')}\" title=\"#{p.display_date.loc('%B')}\">#{p.display_date.loc('%B')}</a></li>"
          closed_m = false
        end

        keep_month = p.display_date.month
        keep_year = p.display_date.year
        cy += 1
        cm += 1
      end
      output << "</ul>\n"
      return output #+ (!closed_y ? otc : '') + (!closed_m ? otc : '')
    end
  end