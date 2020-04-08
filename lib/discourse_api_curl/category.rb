module DiscourseApiCurl
  class Category
    def self.create(command, args)
      params = {
        name: args[:name],
        color: args[:color],
        text_color: args[:text_color]
      }

      request = command.post("/categories", params)
      command.exec(request)
    end
  end
end
