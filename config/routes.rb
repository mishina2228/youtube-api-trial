# frozen_string_literal: true

require 'resque/scheduler/server'
require 'resque/server'

Rails.application.routes.draw do
  authenticated :user, ->(u) {u.admin?} do
    mount Resque::Server.new, at: '/resque'
  end

  get :oauth2callback, to: 'system_settings#oauth2_store_credential'

  scope '(:locale)', locale: /#{I18n.available_locales.map(&:to_s).join('|')}/ do
    root 'channels#index'
    devise_for :users

    resource :system_setting, except: :destroy do
      member do
        put :oauth2_store_credential
      end
    end
    resources :channels, except: [:edit, :update, :destroy] do
      member do
        put :build_statistics
        put :update_snippet
        put :enable
        put :disable
      end
      collection do
        put :build_all_statistics
        put :update_all_snippets
      end
    end

    authenticated :user, ->(u) {u.admin?} do
      namespace :channel_lists do
        resources :search, only: :index
        resources :subscriptions, only: :index
      end

      resources :channels, only: [] do
        scope module: :channels do
          resource :tags, only: [:edit, :update]
        end
      end

      resources :tags, only: :index
    end
  end
end
