i = 0
while i < 200
  puts `SITE='localhost system' ruby app.rb group-remove-member 44 8`
  sleep(1)
  i = i + 1
  exit 1
end
