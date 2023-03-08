module DiscourseApiCurl
  class Topic
    def self.create(command, args)
      params = DiscourseApiCurl.params(args)
        .required(:title, :raw)
        .optional('tags[]', :status, :skip_validations, :external_id, :created_at, :category)
      request = command.post("/posts.json", params)
      command.exec(request)
    end

    def self.update(command, id, args)
      params = DiscourseApiCurl.params(args)
        .optional(:title, :category_id, 'tags[]')
      #request = command.put("/t/-/#{id}.json", params)
      request = command.put("/t/#{id}.json", params)
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

    def self.get(command, id)
      request = command.get("/t/#{id}.json")
      command.exec(request)
    end

    def self.delete(command, id)
      request = command.delete("/t/#{id}.json")
      command.exec(request)
    end

    def self.get_last(command, id)
      request = command.get("/t/#{id}/last.json")
      command.exec(request)
    end

    def self.get_by_external_id(command, external_id)
      request = command.get("/t/external_id/#{external_id}.json")
      command.exec(request)
    end

    def self.posts_ids(command, id, post_ids)
      params = {}
      post_ids_arr = post_ids.split(',')
      post_ids_arr.each do |post_id|
      end
      request = command.get("/t/#{id}/posts.json", params)
      command.exec(request)
    end

  end
end
