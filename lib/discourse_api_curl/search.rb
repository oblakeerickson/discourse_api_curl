module DiscourseApiCurl
  class Search
    def self.q(command, term)
      request = command.get_urlencode("/search.json", term)
      command.exec(request)
    end
  end
end

