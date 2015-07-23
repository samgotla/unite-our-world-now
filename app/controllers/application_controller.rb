class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :check_deleted
  after_action :check_sms_confirmed

  # TODO: remove me!
  if Rails.env.production?
    http_basic_authenticate_with name: ENV['AUTH_USER'], password: ENV['AUTH_PASS']
  end

  protected
  def check_deleted
    if user_signed_in? and current_user.deleted?
      sign_out current_user
      flash[:error] = I18n.t('msg.account_deleted')
      redirect_to new_user_session_path
    end    
  end
  
  def check_verified
    if cannot? :create, Post, current_user
      redirect_to edit_user_registration_path
    end
  end

  private
  def check_sms_confirmed
    if user_signed_in? and current_user.poster? and !current_user.sms_confirmed
      flash[:alert] = I18n.t('msg.please_confirm')
    end
  end

  # TODO: this should be in a new sessions controller
  def after_sign_in_path_for(resource)
    return stored_location_for(resource) || dashboard_path
  end
end
