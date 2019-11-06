i = 0
while i < 200
  puts `ruby app.rb user-create`
  sleep(1)
  i = i + 1
end
