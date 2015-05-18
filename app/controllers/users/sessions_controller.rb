class Users::SessionsController < Devise::RegistrationsController
  def after_sign_in_path_for(user)
    if user.sms_confirmed
      return root_path
    end

    flash[:alert] = I18n.t 'msg.please_confirm'
    return resend_path
  end
end
