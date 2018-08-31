require 'securerandom'

api_key = 'a66d01fbe98cc51b2747d8bfe99f81d7adca18317fbf3c43aa20f340d8e25bfe'
api_username = 'system'

command = ARGV[0]
if !command
  exit
end

case command
when 'category-create'
  c = <<~HERDOC
    curl -i -sS -X POST "http://127.0.0.1:3000/categories" \
    -H "Content-Type: multipart/form-data;" \
    -F "api_key=#{api_key}" \
    -F "api_username=#{api_username}" \
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
    curl -i -sS -X POST "http://127.0.0.1:3000/users" \
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
    curl -i -sS -X PUT "http://127.0.0.1:3000/admin/users/#{user_id}/activate.json" \
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
when 'group-add-members'
  # Example: ruby app.rb group-add-members 41 asdf,fdsg
  group_id = ARGV[1]
  usernames = ARGV[2] #comma separated
  c = <<~HERDOC
    curl -i -sS -X PUT "http://127.0.0.1:3000/groups/#{group_id}/members.json" \
    -H "Content-Type: multipart/form-data;" \
    -F "api_key=#{api_key}" \
    -F "api_username=#{api_username}" \
    -F "usernames=#{usernames}"
  HERDOC
  puts c
  puts
  puts `#{c}`
end
