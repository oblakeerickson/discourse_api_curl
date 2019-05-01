require 'securerandom'
require 'json'
require 'yaml'

@config = YAML.load_file('config.yml')

api_key = @config['api_key']
api_username = @config['api_username']

HOST = @config['host']

command = ARGV[0]
if !command
  exit
end

case command
when 'category-create'
  c = <<~HERDOC
    curl -i -sS -X POST "http://127.0.0.1:3000/categories" \
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
when 'category-create2'
  c = <<~HERDOC
    curl -i -sS -X POST "http://127.0.0.1:3000/categories" \
    -H "Content-Type: multipart/form-data;" \
    -H "Api-Key: #{api_key}" \
    -F "api_username=#{api_username}" \
    -F "name=#{SecureRandom.hex}" \
    -F "color=49d9e9" \
    -F "text_color=f0fcfd" \
    -F "permissions[foobar]=1"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'category-create3'
  api_username = "steve"
  c = <<~HERDOC
    curl -i -sS -X POST "http://127.0.0.1:3000/categories" \
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
  name = SecureRandom.hex[0..19]
  c = <<~HERDOC
    curl -i -sS -X POST "#{HOST}/users" \
    -H "Content-Type: multipart/form-data;" \
    -F "api_key=#{api_key}" \
    -F "api_username=#{api_username}" \
    -F "name=#{name}" \
    -F "username=#{name}" \
    -F "email=#{name}@example.com" \
    -F "password=#{SecureRandom.hex}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'user-activate'
  user_id = ARGV[1]
  c = <<~HERDOC
    curl -i -sS -X PUT "#{HOST}/admin/users/#{user_id}/activate.json" \
    -H "Content-Type: multipart/form-data;" \
    -F "api_key=#{api_key}" \
    -F "api_username=#{api_username}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'user-change-username'
  username = ARGV[1]
  new_username = ARGV[2]
  c = <<~HERDOC
    curl -i -sS -X PUT "http://127.0.0.1:3000/u/#{username}/preferences/username.json" \
    -H "Content-Type: multipart/form-data;" \
    -F "api_key=#{api_key}" \
    -F "api_username=#{api_username}" \
    -F "new_username=#{new_username}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'group-create'
  # Example: ruby app.rb group-create name
  group_name = ARGV[1] || SecureRandom.hex[0..19]
  c = <<~HERDOC
    curl -i -sS -X POST "#{HOST}/admin/groups" \
    -H "Content-Type: multipart/form-data;" \
    -F "api_key=#{api_key}" \
    -F "api_username=#{api_username}" \
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
    -F "api_key=#{api_key}" \
    -F "api_username=#{api_username}" \
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
    -F "api_key=#{api_key}" \
    -F "api_username=#{api_username}" \
    -F "usernames=#{usernames}"
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
    -F "api_key=#{api_key}" \
    -F "api_username=#{api_username}" \
    -F "user_id=#{user_id}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'group-remove-member-json'
  # This case should fail
  # Example: ruby app.rb group-remove-member 41 3
  group_id = ARGV[1]
  user_id = ARGV[2]
  data = {
    api_key: api_key,
    api_username: api_username,
    user_id: user_id
  }
  json = data.to_json
  json = '{"api_key":"7aa202bec1ff70563bc0a3d102feac0a7dd2af96b5b772a9feaf27485f9d31a2","api_username":"system","user_id":"2"}'
  c = <<~HERDOC
    curl -i -sS -X DELETE "#{HOST}/groups/#{group_id}/members.json?api_key=#{api_key}&api_username=#{api_username}" \
    -H "Content-Type: application/json;" \
    -d '{"user_ids":2}'
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
    -F "api_key=#{api_key}" \
    -F "api_username=#{api_username}" \
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
    curl -i -sS -X GET "http://127.0.0.1:3000/directory_items.json?period=weekly&order=likes_received&_=1542406962418" \
    -F "api_key=#{api_key}" \
    -F "api_username=#{api_username}"
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
    -F "api_key=#{api_key}" \
    -F "api_username=#{api_username}" \
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
    curl -i -sS -X GET "#{HOST}/notifications.json?username=#{username}" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'notifications-mark-read'
  # Example: ruby app.rb notifications-mark-read id username
  id = ARGV[1]
  api_username = ARGV[2]
  c = <<~HERDOC
    curl -i -sS -X PUT "#{HOST}/notifications/mark-read" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "id=#{id}"
  HERDOC
  puts c
  puts
  puts `#{c}`
when 'create-pm'
  # Example: ruby app.rb create-pm title target_usernames raw
  title = ARGV[1]
  target_usernames = ARGV[2]
  raw = ARGV[3]
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
when 'create-topic'
  # Example: ruby app.rb create-topic title category_id raw
  category_id = ARGV[1]
  title = ARGV[2] || "#{SecureRandom.hex[0..10]} #{SecureRandom.hex[0..10]} #{SecureRandom.hex[0..10]}"
  raw = ARGV[3] || "#{SecureRandom.hex} #{SecureRandom.hex} #{SecureRandom.hex}"
  c = <<~HERDOC
    curl -i -sS -X POST "#{HOST}/posts.json" \
    -H "Api-Key: #{api_key}" \
    -H "Api-Username: #{api_username}" \
    -F "title=#{title}" \
    -F "category='#{category_id}'" \
    -F "raw=#{raw}"
  HERDOC
  puts c
  puts
  puts `#{c}`
end
