module UsefullStuffs
  def clean_accents_for_urls(input)
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
   def self.clean_html_entities(input)
     input= input.gsub(/&eacute;/,'é')
     input= input.gsub(/&quot;/,'"');
     input= input.gsub(/&amp;/,'&');
     input= input.gsub(/&#39;/,"'");
     input= input.gsub(/&lt;/,'<');
     input= input.gsub(/&gt;/,'>');
     input= input.gsub(/&circ;/,'^');
     input= input.gsub(/&lsquo;/,'‘');
     input= input.gsub(/&rsquo;/,'’');
     input= input.gsub(/&ldquo;/,'“');
     input= input.gsub(/&rdquo;/,'”');
     input= input.gsub(/&bull;/,'•');
     input= input.gsub(/&ndash;/,'–');
     input= input.gsub(/&mdash;/,'—');
     input= input.gsub(/&tilde;/,'˜');
     input= input.gsub(/&trade;/,'™');
     input= input.gsub(/&scaron;/,'š');
     input= input.gsub(/&rsaquo;/,'›');
     input= input.gsub(/&oelig;/,'œ');
     input= input.gsub(/&#357;/,'');
     input= input.gsub(/&#382;/,'ž');
     input= input.gsub(/&Yuml;/,'Ÿ');
     input= input.gsub(/&nbsp;/,' ');
     input= input.gsub(/&iexcl;/,'¡');
     input= input.gsub(/&cent;/,'¢');
     input= input.gsub(/&pound;/,'£');
     input= input.gsub(/&curren;/,' ');
     input= input.gsub(/&yen;/,'¥');
     input= input.gsub(/&brvbar;/,'¦');
     input= input.gsub(/&sect;/,'§');
     input= input.gsub(/&uml;/,'¨');
     input= input.gsub(/&copy;/,'©');
     input= input.gsub(/&ordf;/,'ª');
     input= input.gsub(/&laquo;/,'«');
     input= input.gsub(/&not;/,'¬');
     input= input.gsub(/&shy;/,'­');
     input= input.gsub(/&reg;/,'®');
     input= input.gsub(/&macr;/,'¯');
     input= input.gsub(/&deg;/,'°');
     input= input.gsub(/&plusmn;/,'±');
     input= input.gsub(/&sup2;/,'²');
     input= input.gsub(/&sup3;/,'³');
     input= input.gsub(/&acute;/,'´');
     input= input.gsub(/&micro;/,'µ');
     input= input.gsub(/&para/,'¶');
     input= input.gsub(/&middot;/,'·');
     input= input.gsub(/&cedil;/,'¸');
     input= input.gsub(/&sup1;/,'¹');
     input= input.gsub(/&ordm;/,'º');
     input= input.gsub(/&raquo;/,'»');
     input= input.gsub(/&frac14;/,'¼');
     input= input.gsub(/&frac12;/,'½');
     input= input.gsub(/&frac34;/,'¾');
     input= input.gsub(/&iquest;/,'¿');
     input= input.gsub(/&Agrave;/,'À');
     input= input.gsub(/&Aacute;/,'Á');
     input= input.gsub(/&Acirc;/,'Â');
     input= input.gsub(/&Atilde;/,'Ã');
     input= input.gsub(/&Auml;/,'Ä');
     input= input.gsub(/&Aring;/,'Å');
     input= input.gsub(/&AElig;/,'Æ');
     input= input.gsub(/&Ccedil;/,'Ç');
     input= input.gsub(/&Egrave;/,'È');
     input= input.gsub(/&Eacute;/,'É');
     input= input.gsub(/&Ecirc;/,'Ê');
     input= input.gsub(/&Euml;/,'Ë');
     input= input.gsub(/&Igrave;/,'Ì');
     input= input.gsub(/&Iacute;/,'Í');
     input= input.gsub(/&Icirc;/,'Î');
     input= input.gsub(/&Iuml;/,'Ï');
     input= input.gsub(/&ETH;/,'Ð');
     input= input.gsub(/&Ntilde;/,'Ñ');
     input= input.gsub(/&Ograve;/,'Ò');
     input= input.gsub(/&Oacute;/,'Ó');
     input= input.gsub(/&Ocirc;/,'Ô');
     input= input.gsub(/&Otilde;/,'Õ');
     input= input.gsub(/&Ouml;/,'Ö');
     input= input.gsub(/&times;/,'×');
     input= input.gsub(/&Oslash;/,'Ø');
     input= input.gsub(/&Ugrave;/,'Ù');
     input= input.gsub(/&Uacute;/,'Ú');
     input= input.gsub(/&Ucirc;/,'Û');
     input= input.gsub(/&Uuml;/,'Ü');
     input= input.gsub(/&Yacute;/,'Ý');
     input= input.gsub(/&THORN;/,'Þ');
     input= input.gsub(/&szlig;/,'ß');
     input= input.gsub(/&agrave;/,'à');
     input= input.gsub(/&aacute;/,'á');
     input= input.gsub(/&acirc;/,'â');
     input= input.gsub(/&atilde;/,'ã');
     input= input.gsub(/&auml;/,'ä');
     input= input.gsub(/&aring;/,'å');
     input= input.gsub(/&aelig;/,'æ');
     input= input.gsub(/&ccedil;/,'ç');
     input= input.gsub(/&egrave;/,'è');
     input= input.gsub(/&eacute;/,'é');
     input= input.gsub(/&ecirc;/,'ê');
     input= input.gsub(/&euml;/,'ë');
     input= input.gsub(/&igrave;/,'ì');
     input= input.gsub(/&iacute;/,'í');
     input= input.gsub(/&icirc;/,'î');
     input= input.gsub(/&iuml;/,'ï');
     input= input.gsub(/&eth;/,'ð');
     input= input.gsub(/&ntilde;/,'ñ');
     input= input.gsub(/&ograve;/,'ò');
     input= input.gsub(/&oacute;/,'ó');
     input= input.gsub(/&ocirc;/,'ô');
     input= input.gsub(/&otilde;/,'õ');
     input= input.gsub(/&ouml;/,'ö');
     input= input.gsub(/&divide;/,'÷');
     input= input.gsub(/&oslash;/,'ø');
     input= input.gsub(/&ugrave;/,'ù');
     input= input.gsub(/&uacute;/,'ú');
     input= input.gsub(/&ucirc;/,'û');
     input= input.gsub(/&uuml;/,'ü');
     input= input.gsub(/&yacute;/,'ý');
     input= input.gsub(/&thorn;/,'þ');
     input= input.gsub(/&yuml;/,'ÿ');
     return input
   end
 
   
   
   def get_myspace_icon_url(myspace_url)
       logger.debug "get_myspace_icon Called!"
        return nil if myspace_url.nil?
        #logger.debug "myspace1 #{self.myspace_url}"
        myspace_page  = open('http://www.myspace.com/'+myspace_url)
        #logger.debug "myspace2 #{myspace_page}"
        doc           = Hpricot(myspace_page)
        # logger.debug "myspace3 #{doc}"
        myspace_image = (doc/"#ctl00_Main_ctl00_UserBasicInformation1_hlDefaultImage/img")[0].attributes['src']
        # logger.debug "myspace4 #{myspace_image}"
        return myspace_image
   end
   protected
   def is_devel_mode?
     #return false
     RAILS_ENV=='development'
   end
   
end
