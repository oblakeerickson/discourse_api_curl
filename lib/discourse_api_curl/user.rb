module DiscourseApiCurl
  class User
    def self.create(client, name, email)
      command = ::Command.new(client)
      post = command.post
      c = <<~HERDOC
        -F "name=#{name}" \
        -F "username=#{name}" \
        -F "email=#{email}" \
        -F "password=#{SecureRandom.hex}" \
        -F "active=true" \
        -F "user_fields[1]=#{name}" \
        -F "user_fields[2]=#{SecureRandom.hex[0..10]}"
      HERDOC
      c = post + c
      puts c
      puts
      puts response = `#{c}`
    end
  end
end
