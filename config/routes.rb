Rails.application.routes.draw do
  scope '(:locale)', locale: /#{I18n.available_locales.map(&:to_s).join('|')}/ do
    root 'channels#index'
    devise_for :users

    resources :system_settings, except: :destroy
    resources :channel_statuses
    resources :channels
  end
end
