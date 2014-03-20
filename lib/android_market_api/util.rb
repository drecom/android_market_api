require 'sanitize'

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

    def get_content(url, options = {})
      header = options[:header] ? options[:header].dup : {}
      header["User-Agent"] ||= "ruby"

      supprt_options = [:proxy, :progress_proc, :content_length_proc, :http_basic_authentication]
      supprt_options.each do |name|
        header[name] = options[name] if options[name]
      end
      open(url, header).read
    rescue OpenURI::HTTPError => e
      e.message =~ /^([0-9]{3})/
      status_code = $1
      raise AndroidMarketApi::HTTPError.new("#{e.message} #{url}", :status_code => status_code, :url => url, :cause => e)
    end

    module_function :get_content
  end
end
