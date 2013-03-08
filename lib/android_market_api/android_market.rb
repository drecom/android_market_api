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

  # apps in ranking page
  APP_COUNT_IN_PAGE = 24

  class << self
    include AndroidMarketApi::Util

    def get_top_selling_free_app_in_category(category,position,options={})
      get_app_in_carousel(category_free_url(category, position, options), CATEGORY_TOP_XPATH, options)
    end

    def get_top_selling_paid_app_in_category(category,position,options={})
      get_app_in_carousel(category_paid_url(category, position, options), CATEGORY_TOP_XPATH, options)
    end

    def get_overall_top_selling_free_app(position,options={})
      get_app_in_carousel(top_selling_free_url(position, options), OVERALL_XPATH, options)
    end

    def get_overall_top_selling_paid_app(position,options={})
      get_app_in_carousel(top_selling_paid_url(position, options), OVERALL_XPATH, options)
    end

    def get_overall_top_grossing_app(position,options={})
      get_app_in_carousel(top_grossing_url(position, options), OVERALL_XPATH, options)
    end

    def get_overall_top_selling_new_paid_app(position,options={})
      get_app_in_carousel(top_selling_new_paid_url(position, options), OVERALL_XPATH, options)
    end

    def get_overall_top_selling_new_free_app(position,options={})
      get_app_in_carousel(top_selling_new_free_url(position, options), OVERALL_XPATH, options)
    end

    def get_top_selling_free_apps_in_category(category,position,options={})
      get_apps_in_carousel(category_free_url(category, position, options), CATEGORY_TOP_XPATH, options)
    end

    def get_top_selling_paid_apps_in_category(category,position,options={})
      get_apps_in_carousel(category_paid_url(category, position, options), CATEGORY_TOP_XPATH, options)
    end

    def get_overall_top_selling_free_apps(position,options={})
      get_apps_in_carousel(top_selling_free_url(position, options), OVERALL_XPATH, options)
    end

    def get_overall_top_selling_paid_apps(position,options={})
      get_apps_in_carousel(top_selling_paid_url(position, options), OVERALL_XPATH, options)
    end

    def get_overall_top_grossing_apps(position,options={})
      get_apps_in_carousel(top_grossing_url(position, options), OVERALL_XPATH, options)
    end

    def get_overall_top_selling_new_paid_apps(position,options={})
      get_apps_in_carousel(top_selling_new_paid_url(position, options), OVERALL_XPATH, options)
    end

    def get_overall_top_selling_new_free_apps(position,options={})
      get_apps_in_carousel(top_selling_new_free_url(position, options), OVERALL_XPATH, options)
    end

    def get_developer_app_list(developer_name, position, options={})
      get_apps_in_carousel(developer_app_url(developer_name, position, options), DEVELOPER_APP_XPATH, options)
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
    CATEGORY_TOP_XPATH = "//div[@class='num-pagination-page']//li[@class='goog-inline-block' or @class='z-last-child']"
    OVERALL_XPATH = "//div[@class='num-pagination-page']//li[@class='goog-inline-block' or @class='z-last-child']"
    DEVELOPER_APP_XPATH = "li[@class='goog-inline-block']"

    def category_free_url(category, position, options)
      language = options[:language] || "en"
      "https://play.google.com/store/apps/category/#{category}/collection/topselling_free?start=#{position-1}&hl=#{language}"
    end

    def category_paid_url(category, position, options)
      language = options[:language] || "en"
      "https://play.google.com/store/apps/category/#{category}/collection/topselling_paid?start=#{position-1}&hl=#{language}"
    end

    def top_selling_free_url(position, options)
      language = options[:language] || "en"
      "https://play.google.com/store/apps/collection/topselling_free?start=#{position-1}&hl=#{language}"
    end

    def top_selling_paid_url(position, options)
      language = options[:language] || "en"
      "https://play.google.com/store/apps/collection/topselling_paid?start=#{position-1}&hl=#{language}"
    end

    def top_grossing_url(position, options)
      language = options[:language] || "en"
      "https://play.google.com/store/apps/collection/topgrossing?start=#{position-1}&hl=#{language}"
    end

    def top_selling_new_paid_url(position, options)
      language = options[:language] || "en"
      "https://play.google.com/store/apps/collection/topselling_new_paid?start=#{position-1}&hl=#{language}"
    end

    def top_selling_new_free_url(position, options)
      language = options[:language] || "en"
      "https://play.google.com/store/apps/collection/topselling_new_free?start=#{position-1}&hl=#{language}"
    end

    def developer_app_url(developer_name, position, options)
      language = options[:language] || "en"
      "https://play.google.com/store/apps/developer?id=#{CGI.escape(developer_name)}&start=#{position-1}&hl=#{language}"
    end

    def get_app_in_carousel(url, xpath, options)
      doc = Hpricot(get_content(url))
      buy_div=doc.search(xpath).first
      puts "Getting Application package "+buy_div.attributes['data-docid'] if @@debug
      AndroidMarketApplication.new(buy_div.attributes['data-docid'],options)
    end

    def get_apps_in_carousel(url, xpath, options)
      apps = []
      doc = Hpricot(get_content(url))
      doc.search(xpath).each do |buy_div|
        puts "Getting Application package "+buy_div.attributes['data-docid'] if @@debug
        apps << AndroidMarketApplication.new(buy_div.attributes['data-docid'],options)
      end
      apps
    end
  end
end
