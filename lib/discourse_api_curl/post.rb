module DiscourseApiCurl
  class Post
    def self.latest(command)
      request = command.get("/posts.json")
      command.exec(request)
    end

    def self.show(command, id)
      request = command.get("/posts/#{id}.json")
      command.exec(request)
    end

    def self.replies(command, id)
      request = command.get("/posts/#{id}/replies.json")
      command.exec(request)
    end

    def self.locked(command, id, args)
      params = DiscourseApiCurl.params(args)
        .required(:locked)
      request = command.put("/posts/#{id}/locked.json", params)
      command.exec(request)
    end

    def self.whisper(command, args)
      params = DiscourseApiCurl.params(args)
        .required(:raw, :topic_id)
        .default(whisper: true)
      request = command.post("/posts.json", params)
      command.exec(request)
    end

    def self.delete(command, id, args = {})
      params = DiscourseApiCurl.params(args)
        .optional(:force_destroy)
      request = command.delete("/posts/#{id}.json", params)
      command.exec(request)
    end

    def self.update(command, id, args = {})
      params = DiscourseApiCurl.params(args)
        .required(:raw)
        .optional(:edit_reason)

      h = {}
      params.to_h.each do |k,v|
        h["post[#{k}]"] = v
      end

      request = command.put("/posts/#{id}.json", h)
      command.exec(request)
    end

    def self.like(command, args)
      params = DiscourseApiCurl.params(args)
        .required(:id, :post_action_type_id)
        .default(flag_topic: false)
      request = command.post("/post_actions.json", params)
      command.exec(request)
    end

    def self.likes(command, args)
      request = command.get("/posts/#{id}.json")
      command.exec(request)
    end
  end
end
