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
  end
end
