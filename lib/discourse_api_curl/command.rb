require 'json'

module DiscourseApiCurl
  class Command
    MULTIPART_FORM_DATA = 'multipart/form-data'
    def initialize(client)
      @client = client
    end

    def post(path, params = {})
      c = <<~HERDOC
        curl -i -sS -X POST "#{@client.host}#{path}" \
        -H "Content-Type: #{MULTIPART_FORM_DATA}" \
        -H "Api-Key: #{@client.api_key}" \
        -H "Api-Username: #{@client.api_username}"
      HERDOC
      c.chomp << body(params)
    end

    def put(path, params = {})
      c = <<~HERDOC
        curl -i -sS -X PUT "#{@client.host}#{path}" \
        -H "Content-Type: #{MULTIPART_FORM_DATA}" \
        -H "Api-Key: #{@client.api_key}" \
        -H "Api-Username: #{@client.api_username}"
      HERDOC
      c.chomp << body(params)
    end

    def get(path, params = {})
      c = <<~HERDOC
        curl -i -sSL -X GET "#{@client.host}#{path}" \
        -H "Api-Key: #{@client.api_key}" \
        -H "Api-Username: #{@client.api_username}"
      HERDOC
      c.chomp << body(params)
    end

    def get_urlencode(path, query)
      c = <<~HERDOC
        curl -i -sS -X GET -G "#{@client.host}#{path}" \
        --data-urlencode 'q=#{query}' \
        -H "Api-Key: #{@client.api_key}" \
        -H "Api-Username: #{@client.api_username}"
      HERDOC
    end

    def delete(path, params = {})
      c = <<~HERDOC
        curl -i -sS -X DELETE "#{@client.host}#{path}" \
        -H "Content-Type: #{MULTIPART_FORM_DATA}" \
        -H "Api-Key: #{@client.api_key}" \
        -H "Api-Username: #{@client.api_username}"
      HERDOC
      c.chomp << body(params)
    end

    def body(params)
      unless Hash === params
        params = params.to_h if params.respond_to? :to_h
      end

      fields = ""
      params.each do |k,v|
        f = " "
        f << <<~FIELD
          -F "#{k}=#{v}"
        FIELD
        fields << f.chomp
      end
      fields
    end

    def exec(request)
      pretty_print(request)
      puts
      response = `#{request}`
      response_arr = response.split(/\r?\n/)
      response_content = response_arr.pop(1).first
      puts response_arr
      puts ""
      puts response_content
      puts ""
      begin
      json = JSON.parse(response_content)
      puts JSON.pretty_generate(json)
      rescue JSON::ParserError => e
        puts "Empty Response Body"
      end
    end

    def pretty_format(request)
      pretty = []
      parts = request.split("-H ")
      pretty << parts[0] + " \\"
      pretty << "-H " + parts[1] + " \\"
      pretty << "-H " + parts[2] + " \\"
      body_parts = parts[3]&.split("-F ")
      if parts[3] != nil
        pretty << "-H " + body_parts[0] + " \\"
      end
      if body_parts && body_parts.length > 1
        i = 1
        while i < body_parts.count - 1
          pretty << "-F " + body_parts[i] + " \\"
          i = i + 1
        end
        pretty << "-F " + body_parts[i]
      end
      pretty[-1] = pretty.last.chomp("\\")
      pretty
    end

    def pretty_print(request)
      pretty = pretty_format(request)
      pretty.each do |p|
        puts p
      end
    end
  end
end
