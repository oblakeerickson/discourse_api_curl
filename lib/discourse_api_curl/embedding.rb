module DiscourseApiCurl
  class Embedding
    def self.create(command, args)
      puts args
      params = DiscourseApiCurl.params(args)
        .required(:host, :category_id)

      puts params
      embeddable_host = {
        'embeddable_host[host]': args[:host],
        'embeddable_host[category_id]': args[:category_id]
      }
      request = command.post("/admin/embeddable_hosts", embeddable_host)
      command.exec(request)
    end
  end
end
