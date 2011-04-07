require 'mechanize'
 
class Crawler
 
  EXTENSIONS_IGNORED = %w[.csv .doc .docx .gif .jpg .jpeg .js .mp3 
    .mp4 .mpg .mpeg .pdf .png .ppt .rss .swf .txt .xls .xlsx .xml]
 
  def initialize(starting_url, history_size = 4000, credentials = nil, quiet_mode = false, sitemap = false)
    @bad_pages = []  
    @agent = WWW::Mechanize.new
    @agent.history.max_size = history_size
    @agent.redirect_ok = false
    @sitemap = sitemap
    @sitemap_items = []
  
    if credentials
      creds = credentials.split(':')
      @agent.basic_auth(creds[0], creds[1])
    end
 
    @quiet_mode = quiet_mode
    @starting_url = starting_url
    extract_and_call_urls(starting_url)
    generate_sitemap if @sitemap
  end
 
  def extract_and_call_urls(url)    
    #catch any previously failed requests as well as non-html doc types up front and exit    
    return if @bad_pages.include?(url) || EXTENSIONS_IGNORED.detect{ |ext| url =~ /#{ext}$/ } != nil
 
    #get page
    puts "url: #{url}" unless @quiet_mode
    begin
      page = @agent.get(url)
    rescue => exception
      @bad_pages << url
      puts "url: #{url}, #{exception.message}"
      return
    end
 
    #for any content types we may have missed above, exit if content type is not html
    return if page.content_type.index('text/html') == nil 
 
    @sitemap_items << url if @sitemap
 
    #get links found on page
    links = page.links
 
    #for each link, call the url if not in history




    begin
      links.each do |link|
        # puts "link to extract: #{link.href}"
        # puts "link #{  link.index('http://click.linksynergy.com')  }"
        unless (ignore_url?(link.href) || @agent.visited?(link.href))
          extract_and_call_urls(link.href) 
        # else
        #           puts "link NOT to extract: #{link.href}"
        end
      end    
    end    
  rescue => exception
    puts "link: #{link}, #{exception.message}"
    return
  end

    
    
  private
 
  #def ignore_url?(url)
  #  return true if url.nil?
  #  ( url.index('http://') != nil || 
  #    url.index('https://') != nil || 
  #    url.index('ftp://') != nil || 
  #    url.index('mailto:') != nil || 
  #    url.index('itms://') != nil  ) &&
  #  url.index('http://localhost') == nil &&
  #  url.index('http://127.0.0.1') == nil &&
  #  url.index('http://digg.com') == nil &&
  #  url.index('http://del.icio.us') == nil &&
  #  url.index('http://www.myspace.com') == nil &&
  #  url.index('http://www.facebook.com') == nil &&
  #  url.index('http://www.stumbleupon.com') == nil &&
  #  url.index('http://www.addtoany.com') == nil &&
  #  url.index('/edit') == nil &&
  #  url.index('/admin/') == nil
  #end
 
  def ignore_url?(url)
    return true if url.nil?
    ( url.index('http://') != nil || 
      url.index('https://') != nil || 
      url.index('ftp://') != nil || 
      url.index('mailto:') != nil || 
      url.index('rtsp://') != nil ||
      url.index('itms://')) &&
    url.index('http://localhost') == nil &&
    url.index('http://127.0.0.1') == nil &&
    url.index('http://www.hexadance.com') == nil 
  end
 
  
  
 #
 # url1="http://www.hexadance.com"
 #url2="http://www.hexadance.com/admin/events"
 #url3="http://www.addtoany.com/share_save?linkname=Sven+V%C3%A4th&linkurl=http%3A%2F%2Fwww.hexadance.com%2Fde%2Fartists%2Fsven-vath.html"
 #url4="/fr/home"
 #ignore_url?(url1)
 #ignore_url?(url2)
 # ignore_url?(url3)
 #
 #ignore_url?(url4)
 
 
  def generate_sitemap
    xml_str = ""
    xml = Builder::XmlMarkup.new(:target => xml_str, :indent=>2)
 
    xml.instruct!
    xml.urlset(:xmlns=>'http://www.sitemaps.org/schemas/sitemap/0.9') {
      @sitemap_items.each do |url|
        unless @starting_url == url
          xml.url {
      	    xml.loc(@starting_url + url)
      	    xml.lastmod(Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00"))
      	    xml.changefreq('weekly')
   	  }
        end
      end
    }
 
    save_file(xml_str)
    update_google
  end
 
  # Saves the xml file to disc. This could also be used to ping the webmaster tools
  def save_file(xml)
    File.open(RAILS_ROOT + '/public/sitemap.xml', "w+") do |f|
      f.write(xml)	
    end		
  end
 
  # Notify google of the new sitemap
  def update_google
    sitemap_uri = @starting_url + '/sitemap.xml'
    escaped_sitemap_uri = URI.escape(sitemap_uri)
    Net::HTTP.get('www.google.com',
            '/webmasters/sitemaps/ping?sitemap=' +
             escaped_sitemap_uri)
  end
 
end