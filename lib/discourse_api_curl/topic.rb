module DiscourseApiCurl
  class Topic
    def self.create(command, args)
      params = DiscourseApiCurl.params(args)
        .required(:title, :raw)
      request = command.post("/posts.json", params)
      command.exec(request)
    end
  end
end
