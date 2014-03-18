# Copyright 2011 by Helder Vasconcelos (heldervasc@bearstouch.com).
# All rights reserved.

# Permission is granted for use, copying, modification, distribution,
# and distribution of modified versions of this work as long as the
# above copyright notice is included.

require 'rubygems'
require 'open-uri'
require 'hpricot'
require File.expand_path(File.dirname(__FILE__) + "/util")

class AndroidMarketApplication

  attr_accessor :package, :language,:name, :current_version,:price, :rating_value, :rating_count,
                :updated, :sdk_required, :category, :category_id, :downloads, :size, :content_rating, :description,
                :screenshots, :developer_name, :icon, :update_text

  include AndroidMarketApi::Util

  @@debug=false
  ###########################################################################################
  #  Contructor: Example Usage AndroidMarketApplication.new("com.bearstouch.smsscheduler")
  ############################################################################################
  def initialize(package,options={})

    @package=package
    @language=options[:language] || "en"
    @name=""              # Application Name
    @current_version=""    # Application Current Version
    @price=""              # Application Price
    @rating_value=""      # Rating Value
    @rating_count=""      # Nr of Votes
    @updated=""           # Last Update datetime
    @sdk_required=""      # SDK Required
    @category=""          # Category
    @category_id=""       # Category ID
    @downloads=""         # Downloads
    @size=""               # Application Size
    @content_rating=""     # Content Rating
    @description=""       # Application description
    @developer_name=""    # Developer Name
    @icon=""              # Icon URL
    @screenshots=[]
    @update_text=""
    parse_in_android_market(options)
  end

  def print()
    puts "-------------------------------------------------------------"
    puts " Application Name = "+@name.to_s
    puts " Application Package = "+@package.to_s
    puts " Application Current Version = "+@current_version.to_s
    puts " Application Price = "+@price.to_s
    puts " Application Rating Value = "+@rating_value.to_s
    puts " Application Rating Count = "+@rating_count.to_s
    puts " Application Updated = "+@updated.to_s
    puts " SDK required = "+@sdk_required.to_s
    puts " Category = "+@category.to_s
    puts " Category ID= "+@category_id.to_s
    puts " Nr of Downloads = "+@downloads.to_s
    puts " Size = "+@size.to_s
    puts " Content Rating = "+@content_rating.to_s
    puts " Application description = "+@description.to_s
    puts " Developer Name = "+@developer_name.to_s
    puts " Icon URL = "+@icon.to_s
    puts "-------------------------------------------------------------"
  end

  private

  ############################################
  # =>  Parse Default Page for your localization from Android Market
  ############################################
  def parse_in_android_market(options)

    url="https://play.google.com/store/apps/details?id=#{@package}&hl=#{@language}"
    puts "Getting URL="+url if @@debug
    content = get_content(url, options)
    content.gsub!(%r{</html>(.+)}m, "</html>")
    doc = Hpricot(content)
    fill_current_version(doc.root)
    fill_rating_value(doc.root)
    fill_rating_count(doc.root)
    fill_updated_at(doc.root)
    fill_sdk_required(doc.root)
    fill_category(doc.root)
    fill_category_id(doc.root)
    fill_downloads(doc.root)
    fill_size(doc.root)
    fill_price(doc.root)
    fill_content_rating(doc.root)
    fill_application_name(doc.root)
    fill_description(doc.root)
    fill_screenshots(doc.root)
    fill_developer_name(doc.root)
    fill_icon(doc.root)
    fill_changed_text(doc.root)

  end

  def fill_application_name(doc)
     element=doc.at("div[@itemprop='name']/div")
     if element
       @name=element.inner_html
       puts "Application name ="+@name.to_s  if @@debug
     end
  end

  def fill_current_version(doc)
    element=doc.at("div[@itemprop='softwareVersion']")
    if element
     @current_version=element.inner_html
     puts "Application Version="+@current_version.to_s if @@debug
    end
  end

  def fill_price(doc)
    element=doc.at("meta[@itemprop='price']")
    if element
      @price=element['content']
      puts "Application Price="+@price.to_s if @@debug
    end
  end

  def fill_rating_value(doc)
    element=doc.at("meta[@itemprop='ratingValue']")
    if element
      @rating_value=element['content']
      puts "Application Rating Value ="+@rating_value.to_s if @@debug
    end
  end

  def fill_rating_count(doc)
    element=doc.at("meta[@itemprop='ratingCount']")
    if element
      @rating_count=element['content']
      puts "Application rating_count="+@rating_count.to_s if @@debug
    end
  end

  def fill_updated_at(doc)
    element=doc.at("div[@itemprop='datePublished']")
    if element
      @updated=element.inner_html
      puts "Application updated="+@updated.to_s if @@debug
    end
  end

  def fill_sdk_required(doc)
    element=doc.at("div[@itemprop='operatingSystems']")
    if element
      @sdk_required=element.inner_html
      puts "Application SDK="+@sdk_required.to_s   if @@debug
    end
  end

  def fill_category(doc)
    element=doc.at("a[@class='document-subtitle category']")
    if element
      @category = element.inner_text
      puts "Application category="+@category.to_s   if @@debug
    end
  end

  def fill_category_id(doc)
    element=doc.at("a[@class='document-subtitle category']")
    if element
      category_url = element['href']
      array = category_url.scan %r{/store/apps/category/(.+)$}
      @category_id = array[0][0]
      puts "Application category id="+@category_id.to_s   if @@debug
    end
  end

  def fill_downloads(doc)
    element=doc.at("div[@itemprop='numDownloads']")
    if element
      @downloads=element.inner_html
      puts "Application install category="+@downloads.to_s if @@debug
    end
  end

  def fill_size(doc)
    element=doc.at("div[@itemprop='fileSize']")
    if element
      @size=element.inner_html
      puts "Application Size="+@size.to_s if @@debug
    end
  end

  def fill_content_rating(doc)
    element=doc.at("div[@itemprop='contentRating']")
    if element
      @content_rating=element.inner_html
      puts "Application Content Rating="+@content_rating.to_s if @@debug
    end
  end

  def fill_description(doc)
    element=doc.at("div[@itemprop='description']/div")
    if element
      @description=sanitize(element.inner_html)
      puts "Application Description ="+@description.to_s   if @@debug
    end
  end

  def fill_screenshots(doc)
    element_ar=(doc/"div[@class='thumbnails']/img")
    if element_ar
      element_ar.each  do |img|
        puts "addding "+img['src'].to_s if @@debug
        @screenshots.push(img['src'].to_s)
      end
    end
  end

  def fill_developer_name(doc)
    element=doc.at("a[@class='document-subtitle primary']")
    if element
      @developer_name=element.inner_text
      puts "Application Author= "+@developer_name.to_s if @@debug
    end
  end

  def fill_icon(doc)
    element=doc.at("div[@class='cover-container']/img")
    if element
      @icon=element['src']
      puts "Application Icon= "+@icon.to_s if @@debug
    end
  end

  def fill_changed_text(doc)
    element=(doc/"div[@class='details-section whatsnew']")
    if element
      @update_text=element.inner_html
      puts "Application Update= "+element.inner_html if @@debug
    end
  end

  class << self
    def debug=(is_debug)
      @@debug = is_debug
    end
  end

end


