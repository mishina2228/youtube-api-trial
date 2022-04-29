# frozen_string_literal: true

if Rails.env.development?
  require 'rack-mini-profiler'

  # Enable support for Hotwire TurboDrive page transitions
  Rack::MiniProfiler.config.enable_hotwire_turbo_drive_support = true
  # initialization is skipped so trigger it
  Rack::MiniProfilerRails.initialize!(Rails.application)
end
