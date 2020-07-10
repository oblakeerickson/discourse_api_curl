module DiscourseApiCurl
  class Topic
    def self.create(command, args)
      params = DiscourseApiCurl.params(args)
        .required(:title, :raw)
        .optional('tags[]')
      request = command.post("/posts.json", params)
      command.exec(request)
    end

    def self.set_notification_level(command, id, args)
      params = DiscourseApiCurl.params(args)
        .required(:notification_level)
      request = command.post("/t/#{id}/notifications.json", params)
      command.exec(request)
    end

    def self.update_timestamp(command, id, args)
      params = DiscourseApiCurl.params(args)
        .required(:timestamp)
      request = command.put("/t/#{id}/change-timestamp.json", params)
      command.exec(request)
    end

    def self.create_timer(command, id, args)
      params = DiscourseApiCurl.params(args)
        .optional(:time, :status_type, :based_on_last_post, :category_id)
      request = command.post("/t/#{id}/timer.json", params)
      command.exec(request)
    end
  end
end
