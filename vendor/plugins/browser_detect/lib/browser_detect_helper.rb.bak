
module BrowserDetectHelper

  def browser_is? name
    
    return false if browser_name.nil?
    
    name = name.to_s.strip
    
    return true if browser_name == name
    return true if name == 'mozilla' && browser_name == 'gecko'
    return true if name == 'ie' && browser_name.index('ie')
    return true if name == 'ie7' && browser_name.index('7.0') 
    return true if name == 'webkit' && browser_name == 'safari'
  
  end

  def browser_name
    @browser_name ||= begin
      return if request.env['HTTP_USER_AGENT'].nil?
      ua = request.env['HTTP_USER_AGENT'].downcase
      
      if ua.index('msie') && !ua.index('opera') && !ua.index('webtv')
        'ie'+ua[ua.index('msie')+5].chr
      elsif ua.index('gecko/') 
        'gecko'
      elsif ua.index('opera')
        'opera'
      elsif ua.index('konqueror') 
        'konqueror'
      elsif ua.index('applewebkit/')
        'safari'
      elsif ua.index('mozilla/')
        'gecko'
      end
    
    end
  end  

end


