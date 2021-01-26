module DiscourseApiCurl
  class Upload

    PATH = "/uploads.json"

    def self.create(command, args)
      params = DiscourseApiCurl.params(args)
        .required(:type)
        .optional(:user_id, :synchronous, :file)

      request = command.post(PATH, params)
      command.exec(request)
    end
  end
end

