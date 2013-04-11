# -*- coding: utf-8 -*-
require "rspec"

shared_context :use_stub_content do
  before(:all) do
    # override with stub reader
    module AndroidMarketApi
      module Util
        def get_content(url, options={})
          case url
            when %r{https://play.google.com/store/apps/details}
              read_stub_file "apps_details.txt"
            when %r{https://play.google.com/store/apps/category}
              read_stub_file "apps_category.txt"
            when %r{https://play.google.com/store/apps/collection}
              read_stub_file "apps_collection.txt"
            when %r{https://play.google.com/store/apps/developer}
              read_stub_file "apps_developer.txt"
            else
              read_stub_file "#{CGI.escape(url)}.txt"
          end
        end

        private
        def read_stub_file(filename)
          stub_root_dir = File.expand_path(File.dirname(__FILE__) + "/../../spec/stubs")
          open("#{stub_root_dir}/#{filename}").read
        end
      end
    end
  end
end