module DiscourseApiCurl
  class Notification
    def self.create(command, args)
      params = DiscourseApiCurl.params(args)
        .required(:notification_type, :data, :user_id)
        .optional(:read, :topic_id, :post_number, :post_action_id)
      request = command.post("/notifications.json", params)
      command.exec(request)
    end
  end
end

