module AndroidMarketApi
  class HTTPError < StandardError
    attr_reader :status_code, :url, :cause

    def initialize(message=nil, options={})
      super(message)
      @status_code = options[:status_code].to_i
      @url = options[:url]
      @cause = options[:cause]
    end
  end
end
