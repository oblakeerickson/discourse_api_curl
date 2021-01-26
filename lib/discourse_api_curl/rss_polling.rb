module DiscourseApiCurl
  class RSSPolling

    PATH = "/admin/plugins/rss_polling/feed_settings.json"

    def self.update(command, args)
      params = DiscourseApiCurl.params(args)
        .required(:feed_settings)

      request = command.put(PATH, params)
      command.exec(request)
    end

    def self.get(command)
      request = command.get(PATH)
      command.exec(request)
    end
  end
end

