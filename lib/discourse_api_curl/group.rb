module DiscourseApiCurl
  class Group
    def self.create(command, args = {})
      params = DiscourseApiCurl.params(args)
        .default('group[name]': SecureRandom.hex[0..19])

      request = command.post("/admin/groups.json", params)
      command.exec(request)
    end

    def self.delete(command, id)
      request = command.delete("/admin/groups/#{id}.json")
      command.exec(request)
    end

    def self.list(command)
      request = command.get("/groups.json")
      command.exec(request)
    end

    def self.get(command, name)
      request = command.get("/groups/#{name}.json")
      command.exec(request)
    end

    def self.list_members(command, name)
      request = command.get("/groups/#{name}/members.json")
      command.exec(request)
    end

    def self.add_members(command, id, args)
      params = DiscourseApiCurl.params(args)
        .optional(:usernames, :user_ids, :user_emails)

      request = command.put("/groups/#{id}/members.json", params)
      command.exec(request)
    end
  end
end

