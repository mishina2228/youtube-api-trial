# frozen_string_literal: true

class SystemSettingsController < ApplicationController
  include SystemSettingAware

  before_action :set_system_setting, except: :create
  authorize_resource

  def show
    redirect_to new_system_setting_path unless @system_setting
  end

  def new
    return redirect_to system_setting_path if @system_setting

    @system_setting = SystemSetting.new
  end

  def edit
  end

  def create
    @system_setting = SystemSetting.new(system_setting_params)

    respond_to do |format|
      if @system_setting.save
        format.html {redirect_to system_setting_path, notice: t('helpers.notice.create')}
        format.json {render :show, status: :created, location: @system_setting}
      else
        format.html {render :new, status: :unprocessable_entity}
        format.json {render json: @system_setting.errors, status: :unprocessable_entity}
      end
    end
  end

  def update
    respond_to do |format|
      if @system_setting.update(system_setting_params)
        format.html {redirect_to system_setting_path, notice: t('helpers.notice.update')}
        format.json {render :show, status: :ok, location: @system_setting}
      else
        format.html {render :edit, status: :unprocessable_entity}
        format.json {render json: @system_setting.errors, status: :unprocessable_entity}
      end
    end
  end

  def oauth2_store_credential
    if @system_setting.oauth2?
      @system_setting.store_credential(params[:code])
      redirect_to system_setting_path, notice: t('helpers.notice.oauth2_credential_stored')
    else
      redirect_to system_setting_path, notice: t('helpers.notice.oauth2_required')
    end
  rescue Signet::AuthorizationError => e
    Rails.logger.error e.inspect
    redirect_to system_setting_path, notice: t('helpers.notice.oauth2_credential_store_failed')
  end

  private

  def set_system_setting
    @system_setting = system_setting
  end

  def system_setting_params
    ret = params.expect(system_setting: [:api_key, :auth_method, :client_id, :client_secret, :redirect_uri])
    ret = ret.except(:client_secret) if ret[:client_secret].blank?
    ret
  end
end
