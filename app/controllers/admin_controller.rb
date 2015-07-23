class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_verified

  def user_search
    authorize! :search, current_user

    results = []

    if params[:term].blank?
      term = ''
    else
      term = params[:term].strip().gsub('%', '')
    end

    if term.blank?
      results = User.all.order(:email, :phone).page(params[:page])
    else
      results = User.where('email LIKE ? OR phone LIKE ?', "%#{ term }%",
                           "%#{ term }%")
                .order(:email, :phone).page(params[:page])
    end

    render 'user_search', locals: {
             results: results,
             term: term
           }
  end

  def verify
    authorize! :verify, current_user

    user = User.find(params[:user_id])

    if not user.update(sms_confirmed: true)
      flash[:alert] = I18n.t('msg.general_error')
    end
    
    redirect_to :back
  end

  def promote
    authorize! :promote, current_user

    user = User.find(params[:user_id])

    if not user.update(role: 'moderator')
      flash[:alert] = I18n.t('msg.general_error')
    end

    redirect_to :back
  end

  def demote
    authorize! :demote, current_user

    user = User.find(params[:user_id])

    if not user.update(role: 'poster')
      flash[:alert] = I18n.t('msg.general_error')
    end

    redirect_to :back
  end

  def destroy_user
    authorize! :destroy, current_user

    user = User.find(params[:user_id])

    if not user.destroy
      flash[:alert] = I18n.t('msg.general_error')
    end

    redirect_to :back
  end

  def restore_user
    authorize! :restore, current_user

    user = User.find(params[:user_id])

    if not user.update(deleted_at: nil)
      flash[:alert] = I18n.t('msg.general_error')
    end

    redirect_to :back
  end 
end
