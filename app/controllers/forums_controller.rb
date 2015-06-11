class ForumsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_verified

  check_authorization
  load_and_authorize_resource

  def index
    render 'index', locals: { forums: current_user.all_forums }
  end

  def show
    render 'show', locals: { forum: Forum.find(params[:id]) }
  end

  private
  def check_verified
    if cannot? :post_topic, nil, current_user
      redirect_to edit_user_registration_path
    end
  end
end
