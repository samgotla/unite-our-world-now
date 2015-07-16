class AdminController < ApplicationController
  MIN_TERM_LEN = 3

  before_action :authenticate_user!
  before_action :check_verified

  def user_search
    authorize! :search, current_user

    results = []
    term = params[:term].strip().gsub('%', '')

    if term.length >= MIN_TERM_LEN
      results = User.where('email LIKE ? OR phone LIKE ?', "%#{ term }%",
                           "%#{ term }%")
                .order(:email, :phone).page(params[:page])

      render 'user_search', locals: {
               results: results,
               term: term
             }
    else
      redirect_to dashboard_path
    end
  end
end
