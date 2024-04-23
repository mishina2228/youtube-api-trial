# frozen_string_literal: true

directory '/etc/god' do
  user 'root'
  owner 'root'
  group 'root'
  mode '755'
end

remote_file '/etc/god/master.conf' do
  user 'root'
  owner 'root'
  group 'root'
  mode '644'
  source './cookbooks/god/templates/etc/god/master.conf'
end

template '/etc/god/youtube_api_trial.god' do
  user 'root'
  owner 'root'
  group 'root'
  mode '644'
  action :create
  source './cookbooks/god/templates/etc/god/youtube_api_trial.god.erb'
  variables(
    rails_env: ENV.fetch('RAILS_ENV') {raise('must specify RAILS_ENV')},
    rails_root: File.expand_path('../../', File.dirname(__FILE__)),
    app_name: 'youtube_api_trial',
    user: ENV.fetch('USER', 'root')
  )
end
