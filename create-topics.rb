topic_id = ARGV[0].to_i
i = 0
DAY = 24*60*60
while i < 30
  puts `ruby app.rb create-topic`
  today = Time.now
  day = today - ((i + 1)*DAY)
  puts `ruby app.rb update-timestamp #{topic_id + 1} #{day.to_i}`
  sleep(1)
  i = i + 1
  topic_id = topic_id + 1
end

