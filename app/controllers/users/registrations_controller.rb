class Users::RegistrationsController < Devise::RegistrationsController
  before_action :check_logged_in, only: [ :resend_code, :verify_code ]
  after_action :check_sms_confirmed, only: [ :create, :update ]

  def resend_code
    if current_user.sms_confirmed
      flash[:alert] = I18n.t 'msg.already_confirmed'
      redirect_to root_path
    else

      # Generate new confirmation code
      current_user.generate_sms_code()
      current_user.save()
      
      flash[:notice] = I18n.t 'msg.check_for_code'
      redirect_to edit_user_registration_path
    end
  end

  def verify_code
    if params[:user][:sms_code] == current_user.sms_code
      current_user.update(sms_confirmed: true)

      flash[:notice] = I18n.t 'msg.confirmed'
      redirect_to dashboard_path
    else
      flash[:alert] = I18n.t 'msg.invalid_code'
      redirect_to edit_user_registration_path
    end
  end

  private

  def check_sms_confirmed
    if !current_user.sms_confirmed
      flash[:notice] = I18n.t 'msg.please_confirm'
    end
  end

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
