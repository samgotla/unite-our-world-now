class Users::RegistrationsController < Devise::RegistrationsController
  before_action :check_logged_in, only: [ :resend_code, :verify_code ]

  def resend_code
    if current_user.sms_confirmed
      flash[:alert] = I18n.t 'msg.already_confirmed'
      redirect_to root_path
    else

      # Generate new confirmation code
      current_user.generate_sms_code()
      current_user.save()
      current_user.send_sms_confirmation()
      
      flash[:notice] = I18n.t 'msg.check_for_code'
      redirect_to action: 'edit'
    end
  end

  def verify_code
    if params[:user][:sms_code] == current_user.sms_code
      current_user.update(sms_confirmed: true)

      flash[:notice] = I18n.t 'msg.confirmed'
      redirect_to root_path
    else
      flash[:alert] = I18n.t 'msg.invalid_code'
      redirect_to action: 'edit'
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

    # Sign out user if they haven't confirmed
    flash[:notice] = I18n.t 'msg.please_confirm'

    return edit_user_registration_path
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

  def verify_or_home(user)
    if user.sms_confirmed
      return root_path
    end

    # Sign out user if they haven't confirmed
    flash[:notice] = I18n.t 'msg.please_confirm'

    # Pass confirmation token to next view
    return '%s?token=%s' % [ verify_code_path, user.confirmation_token ]
  end
end
