module DiscourseApiCurl
  class Command
    def initialize(client)
      @client = client
    end

    def post(path, params)
      c = <<~HERDOC
        curl -i -sS -X POST "#{@client.host}#{path}" \
        -H "Content-Type: multipart/form-data;" \
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
      puts `#{request}`
    end

    def pretty_format(request)
      pretty = []
      parts = request.split("-H ")
      pretty << parts[0] + " \\"
      pretty << "-H " + parts[1] + " \\"
      pretty << "-H " + parts[2] + " \\"
      body_parts = parts[3].split("-F ")
      pretty << "-H " + body_parts[0] + " \\"
      i = 1
      while i < body_parts.count - 1
        pretty << "-F " + body_parts[i] + " \\"
        i = i + 1
      end
      pretty << "-F " + body_parts[i]
    end

    def pretty_print(request)
      pretty = pretty_format(request)
      pretty.each do |p|
        puts p
      end
    end
  end
end
