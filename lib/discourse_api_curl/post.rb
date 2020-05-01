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
  end
end
