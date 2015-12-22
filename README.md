# README #

## Production Info ##
* 1 hobby web dyno
* 1 hobby worker dyno (for Sidekiq/SMS)
* Geocodio account for forum generation
* Twilio account and phone number
* ClearDB Punch database
* Heroku Redis hobby database (may have to upgrade in the future)

## Deployment ##
1. Install Heroku toolbelt (https://toolbelt.heroku.com/)
2. Log in to Heroku (https://devcenter.heroku.com/articles/heroku-command)
3. Clone repository
4. Add Heroku remote: `git remote add heroku git@heroku.com:unite-our-world-now.git`
5. Push to Heroku: `git push heroku master`
6. (First deployment only) Init DB: `heroku run "rake db:migrate"`
7. (First deployment only) Create admin: `heroku run "rake users:create_admin"` (note password)

## Environment ##
* `DATABASE_URL`: URL of ClearDB database
* `GEOCODIO_API_KEY`: Geocodio API key
* `REDIS_URL`: URL of Heroku Redis database (for Sidekiq)
* `TWILIO_ACCOUNT_SID`: Twilio account SID
* `TWILIO_AUTH_TOKEN`: Twilio auth token
* `TWILIO_FROM`: Twilio number

## Testing ##
`rake test`