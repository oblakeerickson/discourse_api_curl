module DiscourseApiCurl
  class Command
    def initialize(client)
      @client = client
    end

    def post
      c = <<~HERDOC
        curl -i -sS -X POST "#{@client.host}/users" \
        -H "Content-Type: multipart/form-data;" \
        -H "Api-Key: #{@client.api_key}" \
        -H "Api-Username: #{@client.api_username}"
      HERDOC
      c
    end

    def exec(command)
      puts command
      puts
      puts `#{command}`
    end
  end
end
