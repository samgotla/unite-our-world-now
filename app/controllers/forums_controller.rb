class ForumsController < ApplicationController
  before_action :authenticate_user!

  check_authorization
  load_and_authorize_resource

  def index
    if can? :post_topic, nil, current_user
      render 'index', locals: { forums: current_user.all_forums }
    else
      redirect_to edit_user_registration_path
    end
  end
end
