# YouTube API Trial

YouTubeのAPIを試してみたい

# Commands

### Resqueの設定

Resque, resque-scheduler を God で管理するための設定ファイル作成
```
$ RAILS_ENV=[RAILS_ENV] bundle exec itamae local config/itamae/resque.rb
```

設定ファイル読み込み
```
$ god -c /etc/god/master.conf
```

God から Resque, resque-scheduler の状態確認/起動/再起動/停止
```
$ sudo god status youtube_api_trial
$ sudo god start youtube_api_trial
$ sudo god restart youtube_api_trial
$ sudo god stop youtube_api_trial
```

### ソース更新時の作業

```
bundle
bundle exec rails assets:precompile RAILS_ENV=[RAILS_ENV]
bundle exec pumactl start -F config/puma/[RAILS_ENV].rb
```
