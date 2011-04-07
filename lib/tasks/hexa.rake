require 'lib/crawler'
require 'lib/usefull_stuffs'
include UsefullStuffs
namespace :hexa do
  namespace :cache do
    task :cleanup => :environment do
      SiteSweeper::sweep
    end
    task :crawl do
      start_url = ENV["URL"] || "http://gaengped:3000"
      Crawler.new(start_url, ENV["HISTORY"] || 1000, (ENV["CREDS"] if ENV["CREDS"]), ENV["QUIET"] || false)
    end

    desc "Crawl pages using the Mechanize gem. Set URL variable as a starting point. Set CREDS as username:password if you are hitting a password protected site. If you have more than 1000 pages, set HISTORY to a larger number. By default, each page is displayed in the console. To suppress output and only show errors, set QUIET=true. To generate a Google Sitemap, set SITEMAP=true"
    task :crawl_pages do
      start_url = ENV["URL"] || "http://gaengped:3000"
      sitemap = Crawler.new(start_url, ENV["HISTORY"] || 1000, (ENV["CREDS"] if ENV["CREDS"]), ENV["QUIET"] || false, ENV["SITEMAP"] || true)
    end


  end  


  namespace :sitemap do
    task :all => :environment do
      sitemap=Sitemap.new()
      sitemap.cleanup
      sitemap.generate_sitemap
      sitemap.compress_files
      #sitemap.update_google
    end
    task :cleanup => :environment do
      sitemap=Sitemap.new()
      sitemap.cleanup
    end
    task :preload => :environment do
      sitemap=Sitemap.new()
      sitemap.preload_cache
    end
  end

  namespace :html do
    task :standardize => :environment do
      articles=Article.find(:all, :order=>'id desc')
      articles.each do |article|
        article.body=UsefullStuffs.clean_html_entities(article.body) unless article.body.nil?
        article.citation=UsefullStuffs.clean_html_entities(article.citation) unless article.citation.nil?
        article.synopsis=UsefullStuffs.clean_html_entities(article.synopsis) unless article.synopsis.nil?
        article.intro=UsefullStuffs.clean_html_entities(article.intro) unless article.intro.nil?        
        article.save
      end
    end
  end
end