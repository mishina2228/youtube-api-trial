# YouTube API Trial

YouTubeのAPIを試してみたい

# Commands

Resque, resque-scheduler を God で管理するための設定ファイル作成
```
$ RAILS_ENV=[RAILS_ENV] bundle exec itamae local config/itamae/resque.rb
```

以下のファイルを作成

`/etc/god/master.conf`
```
Dir.glob('/etc/god/*.god') do |config|
  God.load config
end
```

設定ファイル読み込み
```
$ sudo god -c /etc/god/master.conf -P /var/run/god.pid -l /var/log/god.log --log-level info
```

God から Resque, resque-scheduler の状態確認/起動/再起動/停止
```
$ sudo god status youtube_api_trial
$ sudo god start youtube_api_trial
$ sudo god restart youtube_api_trial
$ sudo god stop youtube_api_trial
```
