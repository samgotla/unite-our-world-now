class PostsController < ApplicationController
  class VoteError < StandardError
  end

  before_action :authenticate_user!
  before_action :check_verified

  check_authorization
  load_and_authorize_resource :post

  protect_from_forgery except: [ :upvote, :downvote ]

  def new
    render :new, locals: {
             forum: Forum.find(params[:forum_id]),
             post: Post.new
           }
  end

  def edit
    render :edit, locals: {
             forum: Forum.find(params[:forum_id]),
             post: Post.find(params[:post][:id])
           }
  end

  def show
    render :show, locals: {
             post: Post.find(params[:id])
           }
  end

  def create
    forum = Forum.find(params[:forum_id])
    post = Post.new(post_params)
    
    post.forum = forum
    post.user = current_user

    if post.save
      redirect_to post_path(post)
    else
      render :new, locals: {
               forum: Forum.find(params[:forum_id]),
               post: post
             }
    end
  end

  def vote
    post = Post.find(params[:post_id])
    vote = Vote.find_by(user: current_user, votable: post)
    value = params[:value] == 'up' ? 1: -1

    begin
      if vote
        if not vote.update(value: value)
          raise VoteError
        end
      else
        vote = Vote.create(user: current_user, votable: post, value: value)

        if not vote.id
          raise VoteError
        end
      end
      
      render json: { score: post.score, value: vote.value }

    rescue VoteError
      render json: { error: I18n.t('msg.general_error') }
    end
  end

  def approve
    post = Post.find(params[:post_id])

    if post.update(approved: !post.approved)
      render json: { approved: post.approved }
    else
      render json: { error: I18n.t('msg.general_error') }
    end
  end

  private
  def post_params
    params.require(:post).permit(:subject, :body)
  end
end
