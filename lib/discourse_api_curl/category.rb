module DiscourseApiCurl
  class Category
    def self.create(command, args)
      params = DiscourseApiCurl.params(args)
        .required(:name, :color, :text_color)

      request = command.post("/categories.json", params)
      command.exec(request)
    end

    def self.list(command)
      request = command.get("/categories.json")
      command.exec(request)
    end
  end
end
