# discourse_api_curl

This is a simple tool I created to run one off curl commands to test various
Discourse API endpoints.

I used to use Postman (a gui app), but it currently isn't installed on my
machine and I haven't really missed it until I had to call a bunch of API
endpoints by hand and thought I should just save all my curl requests I write so
that I can call them again whenever I need to.

### Commands

To use this app simply clone the repo and `cd` into it then run:

`ruby app.rb <command>`

Here is a current list of commands

- `category-create`
- `user-create`
- `user-activate <user_id>`
- `group-add-members <group_id> <usernames-comma-separated>`
