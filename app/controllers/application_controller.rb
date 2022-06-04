# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_locale
  rescue_from CanCan::AccessDenied, with: :render_not_found

  protected

  # Set locale information for all links
  def default_url_options(options = {})
    options.merge(locale: locale)
  end

  # Supports multilingual links
  def set_locale
    I18n.locale = locale
  end

  def locale
    @locale ||= params[:locale]
  end

  def require_data(redirect_url, *klass)
    notices = []
    klass.each do |k|
      notices << t('helpers.notice.require_data', model: k.model_name.human) unless k.exists?
    end
    return if notices.blank?

    redirect_to redirect_url, notice: notices
  end

  def take_params
    {
      page: params[:page],
      per: params[:per]
    }
  end
  helper_method :take_params

  def render_not_found
    render file: Rails.root.join('public/404.html'), status: :not_found, layout: false, content_type: 'text/html'
  end
end
