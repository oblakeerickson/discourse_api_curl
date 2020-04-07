module DiscourseApiCurl
  class Client
    attr_reader :host, :api_username, :api_key

    def initialize(host, api_username, api_key)
      @host = host
      @api_username = api_username
      @api_key = api_key
    end
  end
end
