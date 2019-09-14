require 'resque'
require 'resque-scheduler'
require 'resque/scheduler/server'

Resque.redis = 'localhost:6379'
Resque.redis.namespace = "resque:youtube_api_trials:#{Rails.env}"
Resque.logger = Logger.new('log/resque.log', 5, 10.megabytes)
Resque.logger.level = Logger::INFO
Resque.schedule = YAML.load_file(Rails.root.join('config', 'resque_schedule.yml'))
Resque::Scheduler.dynamic = true
Resque::Scheduler.configure do |c|
  c.logfile = Rails.root.join('log', 'resque-scheduler.log')
end
