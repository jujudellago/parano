require "fileutils"
require 'find'
require 'mechanize'

class Sitemap

  LANGUAGES = %w[fr de en]
  ALPHA=%w(0-9 a b c d e f g h i j k l m n o p q r s t u v w x y z)
  def initialize()
    @bad_pages = []  
    @starting_url="http://www.parano-shop.ch"
    @nowutc=Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
    @cntr=0
    @main_items=Array.new
    @agent = WWW::Mechanize.new
    items=Array.new
   # LANGUAGES.each do |lng|
      items<<{:url=>"/galleries",:freq=>'daily'}
    #end
    @main_items<<{:name=>'main_section',:items=>items}
  

    items=Array.new
      Page.find(:all).each do | page|
       # LANGUAGES.each do |lng|
          items<<{:url=>"/pages/#{page.id.to_s}-#{page.permalink}.html",:freq=>'weekly',:timestamp=>page.created_at.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")}
       # end
      end
      Article.find(:all).each do |article|
         items<<{:url=>"/articles/#{article.id.to_s}-#{article.permalink}.html",:freq=>'weekly',:timestamp=>article.created_at.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")}
      end
      items<<{:url=>"/map",:freq=>'weekly',:timestamp=>Time.now.strftime("%Y-%m-%dT%H:%M:%S+00:00")}
      @main_items<<{:name=>'pages_section',:items=>items}

  end



  def cleanup
    FileUtils.rm_r(Dir.glob("#{RAILS_ROOT}/public/*xml*")) rescue Errno::ENOENT
  end


  def generate_sitemap
    xml_index_str=""
    xml_index = Builder::XmlMarkup.new(:target => xml_index_str, :indent=>2)
    xml_index.instruct!
    xml_index.sitemapindex(:xmlns=>'http://www.sitemaps.org/schemas/sitemap/0.9') {
      @main_items.each do |main|
        sitemap_name=main[:name]
        xml_index.sitemap {
          xml_index.loc(@starting_url + "/"+sitemap_name+".xml.gz")
          xml_index.lastmod(@nowutc)
        }
      end
    }

    @main_items.each do |main|
      sitemap_items=main[:items]
      sitemap_name=main[:name]

      xml_str = ""
      xml = Builder::XmlMarkup.new(:target => xml_str, :indent=>2)

      xml.instruct!
      xml.urlset(:xmlns=>'http://www.sitemaps.org/schemas/sitemap/0.9') {
        xml.url {
          xml.loc(@starting_url + "/")
          xml.lastmod(@nowutc)
          xml.changefreq("hourly")
        }

        sitemap_items.each do |item|
          timestamp=item[:timestamp].nil? ? @nowutc : item[:timestamp]
          xml.url {
            @cntr=@cntr+1
            xml.loc(@starting_url + item[:url])
            xml.lastmod(timestamp)
            xml.changefreq(item[:freq])
          }
        end
      }

      save_file(xml_str,sitemap_name)
      #compress_file(sitemap_name)
    end
    save_file(xml_index_str,"sitemap")
    puts "your sitemap has #{@cntr.to_s} items !!"
    puts "scp public/sitemap.xml  jujudell@jujudellago.com:/home/jujudell/apps/mfegg/public/"
    puts "scp public/pages_section.xml.gz  jujudell@jujudellago.com:/home/jujudell/apps/mfegg/public/ "
    puts "scp public/main_section.xml.gz  jujudell@jujudellago.com:/home/jujudell/apps/mfegg/public"
  end

  # Saves the xml file to disc. This could also be used to ping the webmaster tools
  def save_file(xml,name)
    File.open(RAILS_ROOT + "/public/#{name}.xml", "w+") do |f|
      f.write(xml)	
    end		
  end
  def compress_files
    names=""
    @main_items.each do |main|
      sitemap_name=main[:name]
      names<<" #{RAILS_ROOT}/public/#{sitemap_name}.xml "  
    end
    exec "gzip #{names}" 
  end

  def preload_cache
    @main_items.each do |main|
      sitemap_items=main[:items]
      sitemap_items.each do |item|
        url= @starting_url + item[:url]
        puts "getting: #{url}"
        begin
          page = @agent.get(url)
        rescue => exception
          @bad_pages << url
          puts "url: #{url}, #{exception.message}"
        end
      end
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
  #  Net::HTTP.get('www.hexadance.com','/fr/categories/allemagne/articles/pokerflat-ca-bugi.html')


end