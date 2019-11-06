i = 0
while i < 200
  puts `ruby app.rb create-pm "blake.erickson"`
  sleep(1)
  i = i + 1
end
