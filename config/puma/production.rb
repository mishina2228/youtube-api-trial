# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
threads_count = ENV.fetch('RAILS_MAX_THREADS', 5)
threads threads_count, threads_count

# Bind the server to "url". "tcp://", "unix://" and "ssl://" are the only
# accepted protocols.
#
# The default is "tcp://0.0.0.0:9292".
#
# bind 'tcp://0.0.0.0:9292'
bind "tcp://#{`hostname -I | awk '{print $1}'`.chomp}:#{ENV.fetch('PORT', 3001)}"

# Specifies the `environment` that Puma will run in.
#
environment 'production'

# Store the pid of the server in the file at "path".
#
# pidfile '/u/apps/lolcat/tmp/pids/puma.pid'
pidfile "#{Dir.pwd}/tmp/pids/puma.pid"

# Use "path" as the file to store the server info state. This is
# used by "pumactl" to query and control the server.
#
# state_path '/u/apps/lolcat/tmp/pids/puma.state'
state_path "#{Dir.pwd}/tmp/pids/puma.state"

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked webserver processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
# workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory.
#
# preload_app!

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart

before_fork do
  PumaWorkerKiller.config do |config|
    config.ram = 1024
    config.frequency = 1 * 60
    config.percent_usage = 0.65
    config.rolling_restart_frequency = 24 * 3600
    config.reaper_status_logs = true
  end
  PumaWorkerKiller.start
end
