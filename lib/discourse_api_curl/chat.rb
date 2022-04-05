module DiscourseApiCurl
  class Chat
    def self.create(command, channel, args)
      params = DiscourseApiCurl.params(args)
        .required(:message)
      request = command.post("/chat/#{channel}.json", params)
      command.exec(request)
    end
  end
end
