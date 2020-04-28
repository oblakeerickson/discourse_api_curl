module DiscourseApiCurl
  class User
    def self.create(command, args)
      params = DiscourseApiCurl.params(args)
        .required(:name)
        .optional(:active, :staged, :user_fields)
        .default(
          username: args[:name],
          email: "#{args[:name]}@example.com",
          password: SecureRandom.hex,
          active: true,
          approved: true,
          #"user_fields[1]": SecureRandom.hex[0..10],
          #"user_fields[2]": SecureRandom.hex[0..10]
        )

      request = command.post("/users", params)
      command.exec(request)
    end

    def self.update(command, username, args)
      params = DiscourseApiCurl.params(args)
        .optional(:name, :title)

      request = command.put("/u/#{username}.json", params)
      command.exec(request)
    end

    def self.activate(command, user_id)
      request = command.put("/admin/users/#{user_id}/activate.json")
      command.exec(request)
    end

    def self.deactivate(command, user_id)
      request = command.put("/admin/users/#{user_id}/deactivate.json")
      command.exec(request)
    end
  end
end
