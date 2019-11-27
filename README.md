# YouTube API Trial

Ruby on Rails application to get information of youtube channel

# Commands

### Resque settings

Create a configuration file to manage [Resque](https://github.com/resque/resque) and [resque-scheduler](https://github.com/resque/resque-scheduler) with [God](http://godrb.com/)
```
$ RAILS_ENV=[RAILS_ENV] bundle exec itamae local config/itamae/resque.rb
```

Load configuration file
```
$ god -c /etc/god/master.conf
```

Resque, resque-scheduler operation with God
* check the status
* start
* restart
* stop
```
$ sudo god status youtube_api_trial
$ sudo god start youtube_api_trial
$ sudo god restart youtube_api_trial
$ sudo god stop youtube_api_trial
```

### After source update

```
bundle
bundle exec rails assets:precompile RAILS_ENV=[RAILS_ENV]
bundle exec pumactl start -F config/puma/[RAILS_ENV].rb
```

# Configuration Files

### Notify when Resque job failed

If a Resque job fails, a notification is sent by email.  
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