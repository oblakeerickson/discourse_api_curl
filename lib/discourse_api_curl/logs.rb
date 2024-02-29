module DiscourseApiCurl
  class Logs
    def self.list(command)
      request = command.post("/logs/messages.json")
      command.exec(request)
    end

    def self.get(command, id)
      request = command.get("/logs/show/#{id}.json")
      command.exec(request)
    end
  end
end
