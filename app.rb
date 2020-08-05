require 'securerandom'
require 'json'
require 'yaml'
require_relative 'lib/discourse_api_curl'

@config = YAML.load_file(File.join(__dir__, 'config.yml'))
site = ENV['SITE']

if !site
  puts "Please specify a site"
  exit
end

api_key = @config[site]['api_key']
api_username = @config[site]['api_username']

HOST = @config[site]['host']

client = DiscourseApiCurl::Client.new(HOST, api_username, api_key)
request = DiscourseApiCurl::Command.new(client)

command = ARGV[0]
if !command
  puts "Please specify a command"
  exit
end

case command
when 'api-key-create'
  username = ARGV[1]
  description = ARGV[2] || SecureRandom.hex[0..19]
  # Example: ruby app.rb api-key-create username
  c = <<~HERDOC
    curl -i -sS -X POST "#{HOST}/admin/api/keys" \
    -H "Content-Type: application/json;" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "key[username]=#{username}" \
    -F "key[description]=#{description}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'mail-receiver'
  # Example: ruby app.rb mail-receiver
  email = File.read("/home/blake/tmp/email.txt")
  c = <<~HERDOC
    curl -i -sS -X POST "#{HOST}/admin/email/handle_mail" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "email=#{email}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'query-param-creds-test'
  # Example: ruby app.rb query-param-creds-test
  c = <<~HERDOC
    curl -i -sS -X GET "#{HOST}/admin/users/list/active.json?api_key=#{api_key}&api_username=#{api_username}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'query-param-creds-test-2'
  # Example: ruby app.rb query-param-creds-test
  c = <<~HERDOC
    curl -i -sS -X GET "#{HOST}/admin/users/list/active.json?api_key=#{api_key}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'query-param-creds-test-bad-url'
  # Example: ruby app.rb query-param-creds-test
  c = <<~HERDOC
    curl -i -sS -D - -X GET "#{HOST}/bad-url.json?api_key=#{api_key}&api_username=#{api_username}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'category-rss'
  # Example: ruby app.rb category-rss
  c = <<~HERDOC
    curl -i -sS -X GET "#{HOST}/c/lounge/4.rss?api_key=#{api_key}&api_username=#{api_username}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'category-create'
  name = ARGV[1] || SecureRandom.hex
  params = {
    name: name,
    color: "49d9e9",
    text_color: "f0fcfd"
  }
  DiscourseApiCurl::Category.create(request, params)
when 'category-update'
  id = ARGV[1]
  name = ARGV[2] || SecureRandom.hex
  params = {
    name: name,
    color: "49d9e9",
    text_color: "f0fcfd"
  }
  DiscourseApiCurl::Category.update(request, id, params)
when 'category-list'
  DiscourseApiCurl::Category.list(request)
when 'category-show'
  id = ARGV[1]
  DiscourseApiCurl::Category.show(request, id)
when 'posts-latest'
  DiscourseApiCurl::Post.latest(request)
when 'posts-show'
  id = ARGV[1]
  DiscourseApiCurl::Post.show(request, id)
when 'posts-lock'
  id = ARGV[1]
  params = {
    locked: true
  }
  DiscourseApiCurl::Post.locked(request, id, params)
when 'posts-unlock'
  id = ARGV[1]
  params = {
    locked: false
  }
  DiscourseApiCurl::Post.locked(request, id, params)
when 'category-create2'
  c = <<~HERDOC
    curl -i -sS -X POST "#{HOST}/categories" \
    -H "Content-Type: multipart/form-data;" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "name=#{SecureRandom.hex}" \
    -F "color=49d9e9" \
    -F "text_color=f0fcfd" \
    -F "permissions[foobar]=1"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'user-create'
  name = ARGV[1] || SecureRandom.hex[0..19]
  params = {
    name: name,
  }
  DiscourseApiCurl::User.create(request, params)
when 'user-deactivate'
  user_id = ARGV[1]
  DiscourseApiCurl::User.deactivate(request, user_id)
when 'user-activate'
  user_id = ARGV[1]
  DiscourseApiCurl::User.activate(request, user_id)
when 'user-update-username'
  username = ARGV[1]
  new_username = ARGV[2]
  c = <<~HERDOC
    curl -i -sS -X PUT "http://127.0.0.1:3000/u/#{username}/preferences/username.json" \
    -H "Content-Type: multipart/form-data;" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "new_username=#{new_username}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'user-update-trust-level'
  user_id = ARGV[1]
  trust_level = ARGV[2]
  c = <<~HERDOC
    curl -i -sS -X PUT "http://127.0.0.1:3000/admin/users/#{user_id}/trust_level.json" \
    -H "Content-Type: multipart/form-data;" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "level=#{trust_level}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'user-update'
  # Example: ruby app.rb user-update name title
  username = ARGV[1]
  name = ARGV[2] || SecureRandom.hex[0..19]
  title = ARGV[3]
  params = {
    name: name
  }
  if title
    params[:title] = title
  end
  DiscourseApiCurl::User.update(request, username, params)
when 'group-create'
  # Example: ruby app.rb group-create name
  params = ARGV[1] ? { 'group[name]': ARGV[1] } : {}
  DiscourseApiCurl::Group.create(request, params)
when 'group-update'
  # Example: ruby app.rb group-create name
  id = ARGV[1]
  group_name = ARGV[2] || SecureRandom.hex[0..19]
  c = <<~HERDOC
    curl -i -sS -X PUT "#{HOST}/groups/#{id}.json" \
    -H "Content-Type: multipart/form-data;" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "group[name]=#{group_name}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'group-add-members-ids'
  # Example: ruby app.rb group-add-members_ids 41 2,3
  group_id = ARGV[1]
  user_ids = ARGV[2] #comma separated
  c = <<~HERDOC
    curl -i -sS -X PUT "#{HOST}/groups/#{group_id}/members.json" \
    -H "Content-Type: multipart/form-data;" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "user_ids=#{user_ids}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'group-add-members'
  # Example: ruby app.rb group-add-members 41 asdf,fdsg
  group_id = ARGV[1]
  usernames = ARGV[2] #comma separated
  c = <<~HERDOC
    curl -i -sS -X PUT "#{HOST}/groups/#{group_id}/members.json" \
    -H "Content-Type: multipart/form-data;" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "usernames=#{usernames}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'group-add-members-via-email'
  # Example: ruby app.rb group-add-members-via-email 41 asdf,fdsg
  group_id = ARGV[1]
  user_emails = ARGV[2] #comma separated
  c = <<~HERDOC
    curl -i -sS -X PUT "#{HOST}/groups/#{group_id}/members.json" \
    -H "Content-Type: multipart/form-data;" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "user_emails=#{user_emails}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'group-list-members'
  # Example: ruby app.rb group-add-members-via-email 41 asdf,fdsg
  group_id = ARGV[1]
  c = <<~HERDOC
    curl -i -sS -X GET "#{HOST}/groups/#{group_id}/members.json" \
    -H "Content-Type: multipart/form-data;" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'group-remove-members-via-email'
  # Example: ruby app.rb group-add-members-via-email 41 asdf,fdsg
  group_id = ARGV[1]
  user_emails = ARGV[2] #comma separated
  c = <<~HERDOC
    curl -i -sS -X DELETE "#{HOST}/groups/#{group_id}/members.json" \
    -H "Content-Type: multipart/form-data;" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "user_emails=#{user_emails}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'group-add-members-via-admin'
  # Example: ruby app.rb group-add-members-via-admin 41 asdf,fdsg
  group_id = ARGV[1]
  usernames = ARGV[2] #comma separated
  c = <<~HERDOC
    curl -i -sS -X PUT "#{HOST}/admin/groups/#{group_id}/members.json" \
    -H "Content-Type: multipart/form-data;" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "usernames=#{usernames}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'group-add-owners'
  # Example: ruby app.rb group-add-members 41 asdf,fdsg
  group_id = ARGV[1]
  usernames = ARGV[2] #comma separated
  c = <<~HERDOC
    curl -i -sS -X PUT "#{HOST}/admin/groups/#{group_id}/owners.json" \
    -H "Content-Type: multipart/form-data;" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "group[usernames]=#{usernames}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'group-remove-member'
  # Example: ruby app.rb group-remove-member 41 3
  group_id = ARGV[1]
  user_id = ARGV[2]
  c = <<~HERDOC
    curl -i -sS -X DELETE "#{HOST}/groups/#{group_id}/members.json" \
    -H "Content-Type: multipart/form-data;" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "user_id=#{user_id}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'update-site-setting'
  # Example: ruby app.rb update-site-setting name value
  name = ARGV[1]
  value = ARGV[2]
  c = <<~HERDOC
    curl -i -sS -X PUT "http://127.0.0.1:3000/admin/site_settings/#{name}" \
    -H "Content-Type: multipart/form-data;" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "#{name}=#{value}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'get-site-settings'
  # Example: ruby app.rb get-site-settings
  name = ARGV[1]
  value = ARGV[2]
  c = <<~HERDOC
    curl -i -sS -X GET "#{HOST}/admin/site_settings.json" \
    -H "Content-Type: multipart/form-data;" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'directory-items'
  # Example: ruby app.rb directory-items
  c = <<~HERDOC
    curl -i -sS -X GET "#{HOST}/directory_items.json?period=weekly&order=likes_received" \
    -H "APi_KEy: #{api_key}" \
    -H "ApI-UseRnaMe: #{api_username}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'timed-topic-create'
  # Example: ruby app.rb timed-topic-create 41 2019-01-17+08:00-07:00 publish_to_category 1
  topic_id = ARGV[1]
  time = ARGV[2]
  status_type = ARGV[3]
  category_id = ARGV[4]
  c = <<~HERDOC
    curl -i -sS -X POST "#{HOST}/t/#{topic_id}/timer" \
    -H "Content-Type: multipart/form-data;" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "time=#{time}" \
    -F "status_type=#{status_type}" \
    -F "category_id=#{category_id}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'notifications'
  # Example: ruby app.rb notifications username
  username = ARGV[1]
  c = <<~HERDOC
    curl -s -X GET "#{HOST}/notifications.json?username=#{username}" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" | jq .
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'notifications-mark-read'
  # Example: ruby app.rb notifications-mark-read id username
  id = ARGV[1]
  api_username = ARGV[2]
  c = <<~HERDOC
    curl -s -X PUT "#{HOST}/notifications/mark-read" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "id=#{id}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'notifications-mark-all-read'
  # Example: ruby app.rb notifications-mark-all-read username
  api_username = ARGV[1]
  c = <<~HERDOC
    curl -s -X PUT "#{HOST}/notifications/mark-read" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" | jq .
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'unread-notifications'
  # Example: ruby app.rb unread-notifications username
  api_username = ARGV[1]
  c = <<~HERDOC
    curl -s -X GET "#{HOST}/session/current.json" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" | jq .
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'unread'
  # Example: ruby app.rb unread username
  api_username = ARGV[1]
  c = <<~HERDOC
    curl -s -X GET "#{HOST}/unread.json" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" | jq .
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'create-pm'
  # Example: ruby app.rb create-pm target_usernames title raw
  target_usernames = ARGV[1]
  title = ARGV[2] || SecureRandom.hex[0..19]
  raw = ARGV[3] || "#{SecureRandom.hex[0..19]} #{SecureRandom.hex[0..19]} #{SecureRandom.hex[0..19]}"
  c = <<~HERDOC
    curl -i -sS -X POST "#{HOST}/posts.json" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "title=#{title}" \
    -F "target_usernames=#{target_usernames}" \
    -F "raw=#{raw}" \
    -F "archetype=private_message"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'get-pms'
  username = ARGV[1]
  c = <<~HERDOC
    curl -i -sS -X GET "#{HOST}/topics/private-messages/#{username}.json" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'get-pms-sent'
  username = ARGV[1]
  c = <<~HERDOC
    curl -i -sS -X GET "#{HOST}/topics/private-messages-sent/#{username}.json" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'upload-avatar'
  user_id = ARGV[1]
  file = ARGV[2]
  type = "avatar"
  synchronous = true
  c = <<~HERDOC
    curl -i -sS -X POST "#{HOST}/uploads.json" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "files[]=#{file}" \
    -F "type=#{type}" \
    -F "user_id=#{user_id}" \
    -F "synchronous=true"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'update-avatar'
  username = ARGV[1]
  upload_id = ARGV[2]

  params = {
    upload_id: upload_id,
  }
  DiscourseApiCurl::User.update_avatar(request, username, params)
when 'create-topic-in-category'
  # Example: ruby app.rb create-topic title category_id raw
  category_id = ARGV[1]
  title = ARGV[2] || "#{SecureRandom.hex[0..10]} #{SecureRandom.hex[0..10]} #{SecureRandom.hex[0..10]}"
  if ARGV[3] == nil || ARGV[3] == "" || ARGV[3].length == 0
    raw = "#{SecureRandom.hex} #{SecureRandom.hex} #{SecureRandom.hex}"
  else
    raw = ARGV[3]
  end
  tag_data = []
  #tags_arg = ARGV[4]&.split(',')
  #tags_arg.each do |tag|
  #  tag_data << "-F 'tags[]=#{tag}' "
  #end
  c = <<~HERDOC.chomp
    curl -i -sS -X POST "#{HOST}/posts.json" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "title=#{title}" \
    -F "category=#{category_id}" \
    -F "raw=#{raw}"
  HERDOC
  #tag_data.each do |tag|
  #  c = c + " " + tag
  #end
  puts c
  puts
  puts `#{c}`
when 'create-topic'
  # Example: ruby app.rb create-topic title raw
  title = ARGV[2] || "#{SecureRandom.hex[0..10]} #{SecureRandom.hex[0..10]} #{SecureRandom.hex[0..10]}"
  raw = ARGV[3] || "#{SecureRandom.hex} #{SecureRandom.hex} #{SecureRandom.hex}"
  params = {
    title: title,
    raw: raw
  }
  DiscourseApiCurl::Topic.create(request, params)
when 'create-closed-topic'
  # Example: ruby app.rb create-topic title raw
  title = ARGV[2] || "#{SecureRandom.hex[0..10]} #{SecureRandom.hex[0..10]} #{SecureRandom.hex[0..10]}"
  raw = ARGV[3] || "#{SecureRandom.hex} #{SecureRandom.hex} #{SecureRandom.hex}"
  params = {
    title: title,
    raw: raw,
    status: "closed",
  }
  DiscourseApiCurl::Topic.create(request, params)
when 'create-topic-with-tags'
  # Example: ruby app.rb create-topic title raw
  title = ARGV[2] || "#{SecureRandom.hex[0..10]} #{SecureRandom.hex[0..10]} #{SecureRandom.hex[0..10]}"
  raw = ARGV[3] || "#{SecureRandom.hex} #{SecureRandom.hex} #{SecureRandom.hex}"
  tags = ARGV[4] || "#{SecureRandom.hex[0..7]},#{SecureRandom.hex[0..7]}"
  params = {
    title: title,
    raw: raw,
    'tags[]' => tags
  }
  DiscourseApiCurl::Topic.create(request, params)
when 'top-topics'
  # Example: ruby app.rb top-topics
  c = <<~HERDOC
    curl -i -sS -X GET "#{HOST}/top.json" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'top-topics-flag'
  flag = ARGV[1] || 'all'
  # Example: ruby app.rb top-topics
  c = <<~HERDOC
    curl -i -sS -X GET "#{HOST}/top/#{flag}.json" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'latest-topics'
  # Example: ruby app.rb latest-topics
  c = <<~HERDOC
    curl -i -sS -X GET "#{HOST}/latest.json" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'create-topic-json'
  # Example: ruby app.rb create-topic title category_id raw
  category_id = ARGV[1] || "3"
  title = ARGV[2] || "#{SecureRandom.hex[0..10]} #{SecureRandom.hex[0..10]} #{SecureRandom.hex[0..10]}"
  raw = ARGV[3] || "#{SecureRandom.hex} #{SecureRandom.hex} #{SecureRandom.hex}"
  data = "{\\\"title\\\": \\\"#{title}\\\", \\\"category\\\": \\\"#{category_id}\\\", \\\"raw\\\": \\\"#{raw}\\\"}"
  puts data
  c = <<~HERDOC
    curl -i -sS -X POST "#{HOST}/posts.json" \
    -H "Content-Type: application/json" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -d "#{data}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'create-whisper'
  # Example: ruby app.rb create-whisper topic_id
  topic_id = ARGV[1]
  raw = ARGV[2] || "#{SecureRandom.hex} #{SecureRandom.hex} #{SecureRandom.hex}"
  c = <<~HERDOC
    curl -i -sS -X POST "#{HOST}/posts.json" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "raw=#{raw}" \
    -F "topic_id=#{topic_id}" \
    -F "whisper=true"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'create-tag-group'
  # Example: ruby app.rb create-post topic_id
  name = ARGV[1] || "#{SecureRandom.hex}"
  tag = ARGV[2] || "#{SecureRandom.hex}"
  c = <<~HERDOC
    curl -i -sS -X POST "#{HOST}/tag_groups" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "name=#{name}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'create-post'
  # Example: ruby app.rb create-post topic_id
  topic_id = ARGV[1]
  username = ARGV[2] || api_username
  raw = ARGV[3] || "#{SecureRandom.hex} #{SecureRandom.hex} #{SecureRandom.hex}"
  c = <<~HERDOC
    curl -i -sS -X POST "#{HOST}/posts.json" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{username}" \
    -F "raw=#{raw}" \
    -F "topic_id=#{topic_id}" \
    -F "archetype=regular"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'create-closed-post'
  # Example: ruby app.rb create-post topic_id
  topic_id = ARGV[1]
  username = ARGV[2] || api_username
  raw = ARGV[3] || "#{SecureRandom.hex} #{SecureRandom.hex} #{SecureRandom.hex}"
  c = <<~HERDOC
    curl -i -sS -X POST "#{HOST}/posts.json" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{username}" \
    -F "raw=#{raw}" \
    -F "topic_id=#{topic_id}" \
    -F "archetype=regular" \
    -F "status=closed"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'get-posts-from-topic'
  # Example: ruby app.rb update-post post_id
  topic_id = ARGV[1]
  post_ids = ARGV[2]
  post_ids_arr = post_ids.split(',')
  form_data = ""
  post_ids_arr.each do |id|
    form_data << "-F 'post_ids[]=#{id}' "
  end
  puts form_data
  c = <<~HERDOC
    curl -i -sS -X GET "#{HOST}/t/#{topic_id}/posts.json" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "post_ids[]=#{post_ids_arr[0]}" \
    -F "post_ids[]=#{post_ids_arr[1]}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'get-topic'
  topic_id = ARGV[1]
  c = <<~HERDOC
    curl -i -sS -X GET "#{HOST}/t/#{topic_id}.json" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'remove-topic'
  topic_id = ARGV[1]
  c = <<~HERDOC
    curl -i -sS -X DELETE "#{HOST}/t/#{topic_id}.json" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'update-topic'
  # Example: ruby app.rb update-topic topic_id
  topic_id = ARGV[1]
  title = ARGV[2] || "#{SecureRandom.hex} #{SecureRandom.hex}" 
  c = <<~HERDOC
    curl -i -sS -X PUT "#{HOST}/t/-/#{topic_id}.json" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "title=#{title}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'invite-to-topic'
  # Example: ruby app.rb update-topic topic_id
  topic_id = ARGV[1]
  email = ARGV[2] || "discobot" 
  c = <<~HERDOC
    curl -i -sS -X POST "#{HOST}/t/#{topic_id}/invite.json" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "email=#{email}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'bookmark-topic'
  # Example: ruby app.rb bookmark-topic topic_id
  topic_id = ARGV[1]
  c = <<~HERDOC
    curl -i -sS -X PUT "#{HOST}/t/#{topic_id}/bookmark.json" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'update-topic-status'
  # Example: ruby app.rb update-topic-status topic_id
  topic_id = ARGV[1]
  status = ARGV[2] || "closed"
  enabled = ARGV[3] || "true"
  c = <<~HERDOC
    curl -i -sS -X PUT "#{HOST}/t/#{topic_id}/status.json" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "status=#{status}" \
    -F "enabled=#{enabled}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'update-post'
  # Example: ruby app.rb update-post post_id
  post_id = ARGV[1]
  raw = ARGV[2] || "#{SecureRandom.hex} #{SecureRandom.hex} #{SecureRandom.hex}"
  #raw = "\u{1f4a9}"
  #raw = "\u{0000}"
  c = <<~HERDOC
    curl -i -sS -X PUT "#{HOST}/posts/#{post_id}.json" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "post[raw]=#{raw}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'change-owner'
  # Example: ruby app.rb change-owner topic_id username 1,2,3,4,5
  topic_id = ARGV[1]
  username = ARGV[2]
  post_ids = ARGV[3]
  post_ids_arr = post_ids.split(',')
  form_data = ""
  post_ids_arr.each do |id|
    form_data << "-F 'post_ids[]=#{id}' "
  end
  puts form_data
  c = <<~HERDOC
    curl -i -sS -X POST "#{HOST}/t/#{topic_id}/change-owner.json" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "username=#{username}" \
    -F "post_ids[]=#{post_ids_arr[0]}" \
    -F "post_ids[]=#{post_ids_arr[1]}"
  HERDOC
  #c << form_data
  puts c
  puts
  puts `#{c}`
when 'create-shared-draft'
  # Example: ruby app.rb create-topic title category_id raw
  category_id = ARGV[1]
  title = ARGV[2] || "#{SecureRandom.hex[0..10]} #{SecureRandom.hex[0..10]} #{SecureRandom.hex[0..10]}"
  raw = ARGV[3] || "#{SecureRandom.hex} #{SecureRandom.hex} #{SecureRandom.hex}"
  c = <<~HERDOC
    curl -i -sS -X POST "#{HOST}/posts.json" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "title=#{title}" \
    -F "category=#{category_id}" \
    -F "raw=#{raw}" \
    -F "shared_draft=true"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'search'
  # Example: ruby app.rb get-site-settings
  query = ARGV[1]
  c = <<~HERDOC
    curl -i -sS -X GET "#{HOST}/search?q=#{query}" \
    -H "Content-Type: multipart/form-data;" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'canned-replies-anonymous'
  c = <<~HERDOC
    curl -i -sS -X GET "#{HOST}/canned_replies"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'canned-replies'
  c = <<~HERDOC
    curl -i -sS -X GET "#{HOST}/canned_replies" \
    -H "Content-Type: multipart/form-data;" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'canned-replies-delete-as-user'
  id = ARGV[1]
  c = <<~HERDOC
    curl -i -sS -X DELETE "#{HOST}/canned_replies/#{id}" \
    -H "Content-Type: multipart/form-data;" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'set-notification-level'
  id = ARGV[1]
  level = ARGV[2] || '0'
  params = {
    notification_level: level,
  }
  DiscourseApiCurl::Topic.set_notification_level(request, id, params)
when 'update-timestamp'
  id = ARGV[1]
  timestamp = ARGV[2] || '1594291380'
  params = {
    timestamp: timestamp,
  }
  DiscourseApiCurl::Topic.update_timestamp(request, id, params)
when 'create-timer'
  id = ARGV[1]
  timer = ARGV[2] || '1594291380'
  params = {
    timestamp: timestamp,
  }
  DiscourseApiCurl::Topic.update_timestamp(request, id, params)
end
