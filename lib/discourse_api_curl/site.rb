module DiscourseApiCurl
  class Site
    def self.get(command)
      request = command.get("/site.json")
      command.exec(request)
    end
  end
end

