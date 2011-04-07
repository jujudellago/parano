class TranslateController < ApplicationController
  layout LAYOUT_2COLS

  before_filter :basic_auth
#  layout 'application_2col'
  require 'csv'

  # /usr/local/mysql/bin/mysqldump -c hexadance3_development -u root -p --default-character-set=utf8 -n -t --tables  globalize_translations
   def index
     @show_admin_nav=true
     
    @sel_letter= params[:letter].nil? ? "a" : params[:letter]
    sql_conditions=" language_id = '#{ Locale.language.id }' "
    if @sel_letter=="0-9"
       sql_conditions<<"and  tr_key REGEXP '^[0123456789!&%]'"
       @view_translations = ViewTranslation.find(:all, :conditions =>sql_conditions, :order => 'tr_key')
       
    else
      # sql_conditions << " and lower(tr_key) like lower('#{params[:letter]}%')"
       @view_translations = ViewTranslation.find(:all,
        :conditions =>["language_id='?' and lower(tr_key) like lower(?)",Locale.language.id,@sel_letter+"%"], :order => 'tr_key')
       
    end
    if params[:q] 
      #sql_conditions<<" and (lower(tr_key) like lower('%#{params[:q]}%') or lower(text) like lower('%#{params[:q]}%') )"
       @view_translations = ViewTranslation.find(:all,
        :conditions =>["language_id='?' and (lower(tr_key) like lower(?) or lower(text) like lower(?) )",Locale.language.id,"%"+params[:q]+"%","%"+params[:q]+"%"], :order => 'tr_key')
    end
    if params[:latest]
         @view_translations = ViewTranslation.find(:all,
          :conditions =>["language_id='?' ",Locale.language.id], :order => 'id desc',:limit=>100)
    end
    if params[:empty]
      @view_translations = ViewTranslation.find(:all,
        :conditions =>["language_id='?' and  text is null",Locale.language.id], :order => 'tr_key')
       end
    
                                               
                                               
                                               
   end

   def translation_text
     @translation = ViewTranslation.find(params[:id])
     render :text => @translation.text || ""  
   end

   def set_translation_text
     @translation = ViewTranslation.find(params[:id])
     previous = @translation.text
     @translation.text = params[:value]
     @translation.text = previous unless @translation.save
     render :partial => "translation_text", :object => @translation.text  
   end
   def set_viewtranslation_text
     @translation = ViewTranslation.find(params[:id])
     previous = @translation.text
     values=params[:viewtranslation]
     @translation.text = values[:text]
     @translation.text = previous unless @translation.save
     render :update do |page|
       page.replace_html @translation.dom_id, :partial => "translation_form", :locals=>{:tr=>@translation}
     end
   end
   
   
   def destroy
     @translation = ViewTranslation.find(params[:id])
     did=@translation.dom_id
     if @translation.destroy
       render :update do |page|
         page[did].visual_effect :puff
       end
     end
   end
   
   
   def export
     content_type = if request.user_agent =~ /windows/i
       'application/vnd.ms-excel'
     else
       'text/csv'
     end
     # de = 1556
     # en = 1819
     # fr = 1930
     CSV::Writer.generate(output = "") do |csv|
       csv << [ "Key", "FR", "DE", "EN"]
       ViewTranslation.find(:all,:order=>'tr_key',:conditions=>'id>7068').collect(&:tr_key).uniq.each do |key|
          en=ViewTranslation.find_by_tr_key_and_language_id(key,"1819").nil? ? "" : ViewTranslation.find_by_tr_key_and_language_id(key,"1819").text
          fr=ViewTranslation.find_by_tr_key_and_language_id(key,"1930").nil? ? "" : ViewTranslation.find_by_tr_key_and_language_id(key,"1930").text
          de=ViewTranslation.find_by_tr_key_and_language_id(key,"1556").nil? ? "" : ViewTranslation.find_by_tr_key_and_language_id(key,"1556").text
          csv << [key,fr,de,en ]        
       end
     end
     send_data(output, 
     :type => content_type, 
     :filename => "translations.csv")
   end
   
   
   def activate
      @session[:active_translator]="on"
   end
   def deactivate
      @session[:active_translator]="off"
   end
end
