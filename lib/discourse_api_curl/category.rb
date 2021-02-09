module DiscourseApiCurl
  class Category

    def self.show(command, id)
      request = command.get("/c/#{id}/show.json")
      command.exec(request)
    end
    def self.topics(command, slug, id)
      request = command.get("/c/#{slug}/#{id}.json")
      command.exec(request)
    end

    def self.create(command, args)
      params = DiscourseApiCurl.params(args)
        .required(:name)
        .optional(:color, :text_color)

      request = command.post("/categories.json", params)
      command.exec(request)
    end

    def self.update(command, id, args)
      params = DiscourseApiCurl.params(args)
        .optional(:name, :color, :text_color)

      request = command.put("/categories/#{id}.json", params)
      command.exec(request)
    end

    def self.list(command)
      request = command.get("/categories.json")
      command.exec(request)
    end
  end
end
