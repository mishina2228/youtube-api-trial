unless Rails.env.test?
  require 'resque'
  require 'resque-scheduler'
  require 'resque/scheduler/server'
  require 'resque/failure/multiple'
  require 'resque/failure/redis'
  require 'resque/failure/email_notification'

  Resque.redis = 'localhost:6379'
  Resque.redis.namespace = "resque:youtube_api_trials:#{Rails.env}"
  Resque.schedule = YAML.load_file(Rails.root.join('config/resque_schedule.yml'))
  Resque::Scheduler.dynamic = true

  Resque::Failure::Multiple.configure do |multi|
    multi.classes = [Resque::Failure::Redis, Resque::Failure::EmailNotification]
  end
end
