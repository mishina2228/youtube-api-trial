[![CircleCI](https://circleci.com/gh/mishina2228/youtube-api-trial.svg?style=svg)](https://circleci.com/gh/mishina2228/youtube-api-trial)
[![Maintainability](https://api.codeclimate.com/v1/badges/b80a05b702d4a8ee5b13/maintainability)](https://codeclimate.com/github/mishina2228/youtube-api-trial/maintainability)
[![codecov](https://codecov.io/gh/mishina2228/youtube-api-trial/branch/master/graph/badge.svg)](https://codecov.io/gh/mishina2228/youtube-api-trial)

# YouTube API Trial

Ruby on Rails application to get information of YouTube channel

## Prerequisites

- Ruby 2.6+
- Node.js 10.22.1+ || 12+ || 14+
- Yarn 1.x+

## Installation

### Set up Rails app

First, install the gems and javascript packages required by the application:
```
bundle
yarn
```
Next, execute the database migrations/schema setup:
```
bundle exec rails db:setup
```


### Resque settings

Create a configuration file to manage [Resque](https://github.com/resque/resque) and [resque-scheduler](https://github.com/resque/resque-scheduler) with [God](http://godrb.com/)
```
RAILS_ENV=[RAILS_ENV] bundle exec itamae local config/itamae/resque.rb
```

Load configuration file
```
god -c /etc/god/master.conf
```

Resque, resque-scheduler operation with God
* check the status
* start
* restart
* stop
```
god status youtube_api_trial
god start youtube_api_trial
god restart youtube_api_trial
god stop youtube_api_trial
```

### Start the app

```
bundle exec rails assets:precompile RAILS_ENV=[RAILS_ENV]
bundle exec pumactl start -e [RAILS_ENV]
```

## Configuration Files

### Notify when Resque job failed

If a Resque job fails, a notification email will be sent.  
Please fill in the settings of email to config/mail.yml .  
The following is an example when sending from Gmail:

```
production:
  delivery_method: :smtp
  smtp_settings:
    address: 'smtp.gmail.com'
    port: 587
    domain: 'gmail.com'
    user_name: [USER_NAME]
    password: [PASSWORD]
    authentication: 'plain'
    enable_starttls_auto: true
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
