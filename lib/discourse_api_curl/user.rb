module DiscourseApiCurl
  class User
    def self.create(command, args)
      params = {
        name: args[:name],
        username: args[:name],
        email: args[:email],
        password: SecureRandom.hex,
        active: true
      }
      #  -F "user_fields[1]=#{name}" \
      #  -F "user_fields[2]=#{SecureRandom.hex[0..10]}"
      
      request = command.post("/users", params)
      command.exec(request)
    end
  end
end
