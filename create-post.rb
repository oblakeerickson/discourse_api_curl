topic_id = ARGV[0]
i = 0
#while i < rand(1..50)
while i < 300
  puts `ruby app.rb create-post #{topic_id}`
  sleep(1)
  i = i + 1
end
