# -*- coding: utf-8 -*-
require "rspec"
require "cgi"

# if use AndroidMarketApi::Util.get_content, save to tmp/
shared_context :save_content do
  before(:all) do
    module AndroidMarketApi
      module Util
        def get_and_save_content(url, options = {})
          content = orig_get_content(url, options)

          dist_dir = File.expand_path(File.dirname(__FILE__) + "/../../tmp")
          FileUtils.makedirs(dist_dir)

          open("#{dist_dir}/#{CGI.escape(url)}.txt", "wb") do |f|
            f.write(content)
          end

          content
        end

        alias :orig_get_content :get_content
        alias :get_content      :get_and_save_content
      end
    end
  end
end