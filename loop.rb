require 'json'
i = 0
while i < 200
  n = 0
  while n < 10
    # create user
    output = `discourse_api_curl user-create`
    #sleep(1)
    #print '.'
    puts output
    i = i + 1
    n = n + 1
  end
  n = 0
  sleep(7)
  #username = output.split("\n")[0]
  #username = username.split(":")[1].strip
  #puts username

  # create topic
  #topic_output = `ruby app.rb create-topic`
  #topic_response = topic_output.split("\n")[20]
  #hash = JSON.parse(topic_response)
  #topic_id = hash['topic_id']

  #output = `ruby app.rb latest-topics`
  #json_output = output.split("\n")[20]
  #topics_json = JSON.parse(json_output)
  #topics = topics_json['topic_list']['topics']
  #topic_arr = []
  #topics.each do |t|
  #  topic_arr << t['id']
  #end
  #
  ## create post
  #i = 0
  #while i < rand(1..20)
  #  topic_arr.count
  #  rtid = topic_arr[rand(0..topic_arr.count)]
  #  puts `ruby app.rb create-post #{username} #{rtid}`
  #  sleep(32)
  #  i = i + 1
  #end
end

