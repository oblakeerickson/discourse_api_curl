module DiscourseApiCurl
  class Tag
    def self.list(command)
      request = command.get("/tags.json")
      command.exec(request)
    end
  end
end

