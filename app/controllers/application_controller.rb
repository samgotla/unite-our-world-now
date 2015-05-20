class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_action :check_sms_confirmed

  # TODO: remove me!
  if Rails.env.production?
    http_basic_authenticate_with name: ENV['AUTH_USER'], password: ENV['AUTH_PASS']
  end

  private

  def check_sms_confirmed
    if user_signed_in? and current_user.poster? and !current_user.sms_confirmed
      flash[:alert] = I18n.t('msg.please_confirm')
    end
  end
end
