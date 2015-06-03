class Admin::SettingsController < ApplicationController
  
  def index
    @settings = Setting.all
  end
  
  def update
    setting = Setting.find(params[:id])
    setting.subscribe self
    setting.update_me(config: params[:setting])
  end
    
  # Events
  
  def successful_setting_update_event(setting)
    redirect_to admin_tasks_path
  end

  def successful_setting_create_event(setting)
    redirect_to admin_tasks_path
  end

    
end