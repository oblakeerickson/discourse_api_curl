id = ARGV[0]
i = 0
while i < 1
  puts `SITE=laptop discourse_api_curl invite-perform #{id}`
  i = i + 1
end
