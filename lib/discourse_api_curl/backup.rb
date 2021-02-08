module DiscourseApiCurl
  class Backup
    def self.list(command)
      request = command.get("/admin/backups.json")
      command.exec(request)
    end

    def self.create(command, args)
      params = DiscourseApiCurl.params(args)
        .required(:with_uploads)
      request = command.post("/admin/backups.json", args)
      command.exec(request)
    end

    def self.send_download_email(command, filename)
      request = command.put("/admin/backups/#{filename}")
      command.exec(request)
    end

    def self.download_backup(command, filename, args)
      params = DiscourseApiCurl.params(args)
        .required(:token)
      request = command.get("/admin/backups/#{filename}", args)
      command.exec(request)
    end
  end
end
