class Users::RegistrationsController < Devise::RegistrationsController
  before_action :check_logged_in, only: [ :resend_code, :verify_code ]

  def resend_code
    if current_user.sms_confirmed
      redirect_to root_path
    else
      current_user.send_sms_confirmation()
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

  # RegistrationsController#update pulled from Devise source
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated

      # Don't update flash message if XHR
      if is_flashing_format? and !request.xhr?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
                      :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, bypass: true

      generate_forums()

      # Send blank JSON response if updating via XHR
      # (for updating location only)
      if request.xhr?
        render json: {}
      else
        respond_with resource, location: after_update_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  private

  def generate_forums

    # Only generate forums when zip code is changed
    if self.resource.previous_changes()[:zip_code] and !self.resource.zip_code.blank?

      # Override flash message if generating forums
      if Forum.generate(self.resource)
        flash[:notice] = I18n.t('msg.forums_created')
      else
        flash[:alert] = I18n.t('msg.forums_error')
      end
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
      :current_password,
      :latitude,
      :longitude,
      :zip_code
    )
  end
end
