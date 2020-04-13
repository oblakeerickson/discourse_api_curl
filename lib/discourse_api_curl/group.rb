module DiscourseApiCurl
  class Group
    def self.create(command, args = {})
      params = DiscourseApiCurl.params(args)
        .default('group[name]': SecureRandom.hex[0..19])

      request = command.post("/admin/groups", params)
      command.exec(request)
    end
  end
end

