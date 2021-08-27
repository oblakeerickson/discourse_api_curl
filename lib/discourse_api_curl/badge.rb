module DiscourseApiCurl
  class Badge
    PATH = "/admin/badges"

    def self.list(command)
      request = command.get("#{PATH}.json")
      command.exec(request)
    end

    def self.create(command, args)
      params = DiscourseApiCurl.params(args)
        .required(:name, :badge_type_id)
        .optional()
      request = command.post("#{PATH}.json", params)
      command.exec(request)
    end

    def self.get(command, id)
      request = command.get("#{PATH}/#{id}.json")
      command.exec(request)
    end

    def self.update(command, id, args)
      params = DiscourseApiCurl.params(args)
        .required(:name, :badge_type_id)
        .optional()
      request = command.put("#{PATH}/#{id}.json", params)
      command.exec(request)
    end

    def self.delete(command, id)
      request = command.delete("#{PATH}/#{id}.json")
      command.exec(request)
    end

    def self.get_award(command, id)
      request = command.get("#{PATH}/award/#{id}.json")
      command.exec(request)
    end
  end
end
