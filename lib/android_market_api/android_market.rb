# Copyright 2011 by Helder VAsconcelos (heldervasc@bearstouch.com).
# All rights reserved.

# Permission is granted for use, copying, modification, distribution,
# and distribution of modified versions of this work as long as the
# above copyright notice is included.

require 'rubygems'
require 'hpricot' 
require 'open-uri'
require 'cgi'
require File.expand_path(File.dirname(__FILE__) + "/android_market_application")

class AndroidMarket

  @@game_categories=Array.[]('ARCADE','BRAIN','CARDS','CASUAL','GAME_WALLPAPER','RACING','SPORTS_GAMES','GAME_WIDGETS')
  @@application_categories=Array.[]('BOOKS_AND_REFERENCE','BUSINESS','COMICS','COMMUNICATION','EDUCATION','ENTERTAINMENT','FINANCE','HEALTH_AND_FITNESS','LIBRARIES_AND_DEMO','LIFESTYLE','APP_WALLPAPER','MEDIA_AND_VIDEO','MEDICAL','MUSIC_AND_AUDIO','NEWS_AND_MAGAZINES','PERSONALIZATION','PHOTOGRAPHY','PRODUCTIVITY','SHOPPING','SOCIAL','SPORTS','TOOLS','TRANSPORTATION','TRAVEL_AND_LOCAL','WEATHER','APP_WIDGETS')
  @@languages=Array.[]('en','pt_PT','pt_BR','es','es_419','fr','it','es')

  @@debug=false

  class << self
    def get_top_selling_free_app_in_category(category,position,language='en')
      url = "https://play.google.com/store/apps/category/#{category}?start=#{position-1}&hl=#{language}"
      xpath = "//div[@data-analyticsid='top-free']//div[@class='goog-inline-block carousel-cell']"
      get_app_in_summaries(url, xpath, language)
    end

    def get_top_selling_paid_app_in_category(category,position,language='en')
      url = "https://play.google.com/store/apps/category/#{category}?start=#{position-1}&hl=#{language}"
      xpath = "//div[@data-analyticsid='top-paid']//div[@class='goog-inline-block carousel-cell']"
      get_app_in_summaries(url, xpath, language)
    end

    def get_overall_top_selling_free_app(position,language='en')
      url = "https://play.google.com/store/apps/collection/topselling_free?start=#{position-1}&hl=#{language}"
      xpath = "//div[@class='num-pagination-page']//li[@class='goog-inline-block']"
      get_app_in_summaries(url, xpath, language)
    end

    def get_overall_top_selling_paid_app(position,language='en')
      url = "https://play.google.com/store/apps/collection/topselling_paid?start=#{position-1}&hl=#{language}"
      xpath = "//div[@class='num-pagination-page']//li[@class='goog-inline-block']"
      get_app_in_summaries(url, xpath, language)
    end

    def get_top_selling_free_apps_in_category(category,position,language='en')
    end

    def get_developer_app_list(developer_name, position, language='en')
      url="https://play.google.com/store/apps/developer?id="+CGI.escape(developer_name)+"&start="+(position-1).to_s+"&hl="+language
      doc = Hpricot(open(url,'User-Agent' => 'ruby'))
      buy_lis=doc.search("li[@class='goog-inline-block']")
      apps = Array.new
      buy_lis.each do |buy_li|
        puts "Getting Application package "+buy_li.attributes['data-docid'] if @@debug
        apps << AndroidMarketApplication.new(buy_li.attributes['data-docid'],language)
      end
      return apps
    end

    def get_languages()
      return @@languages
    end

    def get_game_categories()
      return @@game_categories
    end

    def get_application_categories()
      return @@application_categories
    end

    def debug=(is_debug)
      @@debug = is_debug
    end

    private
    def get_app_in_summaries(url, xpath, language)
      doc = Hpricot(open(url,'User-Agent' => 'ruby'))
      buy_div=doc.search(xpath).first
      puts "Getting Application package "+buy_div.attributes['data-docid'] if @@debug
      AndroidMarketApplication.new(buy_div.attributes['data-docid'],language)
    end

  end
end
