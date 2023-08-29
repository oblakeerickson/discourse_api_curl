module DiscourseApiCurl
  class Invite
    def self.create_link_add_to_group_by_id(command, args = {})
      params = DiscourseApiCurl.params(args)
        .default(
          skip_email: false,
          max_redemptions_allowed: 1,
        )
        .required(
          :group_ids,
        )
        .optional(
          :email
        )
      request = command.post("/invites.json", params)
      command.exec(request)
    end

    def self.perform_accept_invite(command, id, args = {})
      params = DiscourseApiCurl.params(args)
        .default(
          username: args[:name],
          email: "#{args[:name]}@example.com",
          password: SecureRandom.hex,
        )
        .required(
          :name
        )
        .optional(
          :email_token,
          :timezone,
          :user_custom_fields
        )
      request = command.put("/invites/show/#{id}.json", params)
      command.exec(request)
    end
  end
end
