module DiscourseApiCurl
  class Category
    def self.create(command, args)
      params = DiscourseApiCurl.params(args)
        .required(:name, :color, :text_color)

      request = command.post("/categories", params)
      command.exec(request)
    end
  end
end
