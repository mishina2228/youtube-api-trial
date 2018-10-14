class SystemSettingsController < ApplicationController
  before_action :set_system_setting

  def index
    if @system_setting.blank?
      redirect_to new_system_setting_path
      return
    end
    redirect_to system_setting_path(@system_setting)
  end

  def show
  end

  def new
    if @system_setting.present?
      redirect_to system_setting_path(@system_setting)
      return
    end
    @system_setting = SystemSetting.new
  end

  def edit
  end

  def create
    @system_setting = SystemSetting.new(system_setting_params)

    respond_to do |format|
      if @system_setting.save
        format.html {redirect_to @system_setting, notice: t('helpers.notice.create')}
        format.json {render :show, status: :created, location: @system_setting}
      else
        format.html {render :new}
        format.json {render json: @system_setting.errors, status: :unprocessable_entity}
      end
    end
  end

  def update
    respond_to do |format|
      if @system_setting.update(system_setting_params)
        format.html {redirect_to @system_setting, notice: t('helpers.notice.update')}
        format.json {render :show, status: :ok, location: @system_setting}
      else
        format.html {render :edit}
        format.json {render json: @system_setting.errors, status: :unprocessable_entity}
      end
    end
  end

  private

  def set_system_setting
    @system_setting = SystemSetting.first
  end

  def system_setting_params
    params.require(:system_setting).permit(:api_key)
  end
end
