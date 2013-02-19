require 'sanitize'
require 'net/http'

module AndroidMarketApi
  module Util

    # remove html tags
    # <br> -> \n
    def sanitize(str)
      return str unless str
      str = str.gsub(%r{<br\s*?/?>}, "\n")
      Sanitize.clean(str)
    end

    module_function :sanitize

    def get_content(url, headers = {})
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl =  url.start_with?("https://") if http.respond_to?(:use_ssl=)

      res = http.start {|http|
        req = Net::HTTP::Get.new(url)
        headers.each do |name, value|
          req[name] = value
        end
        http.request(req)
      }

      res.value
      res.body
    end

    module_function :get_content

  end
end
