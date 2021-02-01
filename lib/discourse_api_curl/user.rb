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
          #approved: false,
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

    def self.update_avatar(command, username, args)
      params = DiscourseApiCurl.params(args)
        .required(:upload_id, :type)
      request = command.put("/u/#{username}/preferences/avatar/pick.json", params)
      command.exec(request)
    end

    def self.update_email(command, username, args)
      params = DiscourseApiCurl.params(args)
        .required(:email)
      request = command.put("/u/#{username}/preferences/email.json", params)
      command.exec(request)
    end

    def self.suspend(command, user_id, args)
      params = DiscourseApiCurl.params(args)
        .required(:suspend_until, :reason)
        .optional(:message, :post_action, :not_permitted)
      request = command.put("/admin/users/#{user_id}/suspend.json", params)
      command.exec(request)
    end

    def self.unsuspend(command, user_id)
      request = command.put("/admin/users/#{user_id}/unsuspend.json")
      command.exec(request)
    end

    def self.public_get(command, username)
      request = command.get("/u/#{username}.json")
      command.exec(request)
    end

    def self.get(command, id)
      request = command.get("/admin/users/#{id}.json")
      command.exec(request)
    end

    def self.delete(command, id)
      request = command.delete("/admin/users/#{id}.json")
      command.exec(request)
    end

    def self.list(command, flag)
      request = command.get("/admin/users/list/#{flag}.json")
      command.exec(request)
    end

    def self.by_external(command, external_id)
      request = command.get("/u/by-external/#{external_id}.json")
      command.exec(request)
    end

    def self.user_actions(command, args)
      params = DiscourseApiCurl.params(args)
        .required(:offset, :username, :filter)
        .to_h

      request = command.get("/user_actions.json?offset=#{params[:offset]}&username=#{params[:username]}&filter=#{params[:filter]}")
      command.exec(request)
    end

    def self.log_out(command, id)
      request = command.post("/admin/users/#{id}/log_out.json")
      command.exec(request)
    end

    def self.refresh_gravatar(command, username)
      request = command.post("/user_avatar/#{username}/refresh_gravatar.json")
      command.exec(request)
    end

    def self.password_reset(command, args)
      params = DiscourseApiCurl.params(args)
        .required(:login)
      request = command.post("/session/forgot_password.json", params)
      command.exec(request)
    end
  end
end
