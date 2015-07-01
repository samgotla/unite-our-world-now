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
    forum = Forum.find(params[:id])

    render 'show', locals: {
             forum: forum,
             posts: forum.approved_posts
           }
  end

  def all_posts
    forum = Forum.find(params[:id])

    render 'show', locals: {
             forum: forum,
             posts: forum.posts
           }
  end

  def children
    forum = Forum.find(params[:id])
    
    render 'children', locals: {
             forum: forum,
             children: forum.children
           }
  end

  def search
    results = []
    term = params[:term].strip().gsub('%', '')

    if term.length >= Forum::MIN_TERM_LEN
      results = Forum.where('name LIKE ?', "%#{ term }%")
                .order(:name).page(params[:page])

      render 'search', locals: {
               results: results,
               term: term
             }
    else
      redirect_to forums_path
    end
  end

  private
  def check_forum_exists
    if !current_user.forum
      flash[:alert] = I18n.t('msg.enter_location')
      redirect_to edit_user_registration_path
    end
  end
end
