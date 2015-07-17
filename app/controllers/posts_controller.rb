class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_verified

  check_authorization
  load_and_authorize_resource :forum
  load_and_authorize_resource :post, through: 'forum'

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
      redirect_to forum_post_path(forum, post)
    else
      render :new, locals: {
               forum: Forum.find(params[:forum_id]),
               post: post
             }
    end
  end

  def update
  end

  def upvote
    post = Post.find(params[:post_id])
    vote = Vote.find_by(user: current_user, votable: post)

    if vote
      vote.update(value: 1)
    else
      vote = Vote.create(user: current_user, votable: post, value: 1)
    end

    render json: { score: post.score(), value: vote.value }
  end

  def downvote
    post = Post.find(params[:post_id])
    vote = Vote.find_by(user: current_user, votable: post)

    if vote
      vote.update(value: -1)
    else
      vote = Vote.create(user: current_user, votable: post, value: -1)
    end

    render json: { score: post.score(), value: vote.value }
  end

  private
  def post_params
    params.require(:post).permit(:subject, :body)
  end
end
