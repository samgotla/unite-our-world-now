class Users::RegistrationsController < Devise::RegistrationsController
  before_action :check_logged_in, only: [ :resend_code, :verify_code ]

  def resend_code
    if current_user.sms_confirmed
      redirect_to root_path
    else
      current_user.send_sms_confirmation(true)
      redirect_to edit_user_registration_path
    end
  end

  def verify_code
    if params[:user][:sms_code] == current_user.sms_code
      current_user.update!(sms_confirmed: true)

      flash[:notice] = I18n.t 'msg.confirmed'
      redirect_to dashboard_path
    else
      flash[:alert] = I18n.t 'msg.invalid_code'
      redirect_to edit_user_registration_path
    end
  end

  private

  # Use external method since Devise controllers are exempt from
  # authenticate_user!
  def check_logged_in
    if !user_signed_in?
      redirect_to new_user_session_path
    end

    return
  end

  def after_sign_up_path_for(user)
    return edit_user_registration_path
  end

  def after_update_path_for(user)
    return (user.sms_confirmed ? dashboard_path: edit_user_registration_path)
  end

  def sign_up_params
    params.require(:user).permit(
      :email,
      :phone,
      :password,
      :password_confirmation
    )
  end

  def account_update_params
    params.require(:user).permit(
      :email,
      :phone,
      :password,
      :password_confirmation,
      :current_password
    )
  end
end
