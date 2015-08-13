# README #

## Deployment ##
1. Install Heroku toolbelt (https://toolbelt.heroku.com/)
2. Log in to Heroku (https://devcenter.heroku.com/articles/heroku-command)
3. Clone repository
4. Add Heroku remote: `git remote add heroku git@heroku.com:unite-our-world-now.git`
5. Push to Heroku: `git push heroku master`
6. (First deployment only) Init DB: `heroku run "rake db:migrate"`
7. (First deployment only) Create admin: `heroku run "users:create_admin"` (note password)