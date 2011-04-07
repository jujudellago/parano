# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
 
  include HtmlCleaner
  include AuthenticatedSystem
  helper :transparent_message
  helper :juju
  helper :google
  helper :html
  helper_method :logged_in?, :admin?
  around_filter :set_language
  before_filter :set_locale
  def set_locale
   # default_locale = 'fr-FR'
   # request_language = request.env['HTTP_ACCEPT_LANGUAGE']
   # request_language = request_language.nil? ? nil : request_language[/[^,;]+/]
   # request_language = request_language.nil? ? nil : request_language[/[^-]+/]
   # @locale = params[:locale] || session[:locale] || request_language || default_locale
   # session[:locale] = @locale
   # RAILS_DEFAULT_LOGGER.error("\n set_locale: session[:locale]=#{session[:locale]}  \n")
   # begin
   #   Locale.set @locale
   # rescue
   #   Locale.set default_locale
   # end
   #  t
   
   @locale ='fr'
   session[:locale] = @locale
    
  end
   def set_language
      RAILS_DEFAULT_LOGGER.error("\n set_language: session[:locale]=#{session[:locale]}  \n")
        Gibberish.use_language(session[:locale]) { yield }
        # Gibberish.use_language(DEFAULT_LANGUAGE) { yield }
      end
  # def method_missing(methodname, *args)
  #     @methodname = methodname
  #     @args = args
  #     render 'home/e404', :status => 404
  #  end

   def pages_for(size, options = {})
     default_options = {:per_page => 10}
     options = default_options.merge options
     pages = Paginator.new self, size, options[:per_page], (params[:page]||1)
     return pages
   end
  def set_charset
     respond_to do |requete|
       requete.html {
         content_type = headers["Content-Type"] || "text/html" 
         if /^text\//.match(content_type)
           headers["Content-Type"] = "#{content_type}; charset=utf-8" 
         end
       }
       requete.js {
         headers["Content-Type"] = "text/javascript"
       }
     end
   end
   
   def newpass( len )
       chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
       newpass = ""
       1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
       return newpass
   end
   
   def get_roles_combinations(s)
      a=Array.new()
      a<<s+"1_2_3_4_5"
      a<<s+"2_3_4_5"
      a<<s+"3_4_5"
      a<<s+"2_3_4"
      a<<s+"2_3"
      a<<s+"3_2"
      a<<s+"3_4"
      a<<s+"3_5"
      a<<s+"4_5"
      a<<s+"3"
      a<<s+"4"
      a<<s+"5"
      a<<s+"2"
      a<<s
      return a
    end
    def get_languages(s)
      a=Array.new()
      a<<s+"fr-"
      a<<s+"de-"
      a<<s+"en-"
      return a
    end
    
   
    

end


class String
  def cleanup_html
    return "#{self.gsub!(/<[a-zA-Z\/][^>]*>/){}}"
  end
  
  def remove_http
     return "#{self.gsub(/http:\/\//){}}"
  end
  
  def escape_single_quotes
    self.gsub(/[']/, '\\\\\'')
  end
  def escape_double_quotes
    self.gsub(/["]/, '\\\\"')
  end

  def remove_escaped_single_quotes
    #self.gsub(/\\'/, '&quot;')
    self.gsub("\\'", "'")
  end

  def extract_email
    self.match(/[A-Za-z\d_\-\.+]+@[A-Za-z\d_\-\.]+\.[A-Za-z\d_\-]+/)[0]
  rescue NoMethodError
    nil
  end

  # &egrave; è
  # &eacute; é
  # &ecirc; ê
  # &agrave; à
  # &uuml; ü
  # &auml;  ä

end

