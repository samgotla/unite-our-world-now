class ForumsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_verified
  before_action :check_forum_exists, only: 'index'

  check_authorization
  load_and_authorize_resource

  def index
    render 'index', locals: { forums: current_user.all_forums }
  end

  def show
    render 'show', locals: { forum: Forum.find(params[:id]) }
  end

  def children
    forum = Forum.find(params[:id])
    render 'children', locals: {
             forum: forum,
             children: forum.children
           }
  end

  private
  def check_verified
    if cannot? :post_topic, nil, current_user
      redirect_to edit_user_registration_path
    end
  end

  def check_forum_exists
    if !current_user.forum
      flash[:alert] = I18n.t('msg.enter_location')
      redirect_to edit_user_registration_path
    end
  end
end
