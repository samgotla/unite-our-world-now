class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_verified

  check_authorization
  load_and_authorize_resource

  def create
    post = Post.find(params[:post_id])
    comment = Comment.new(comment_params)

    comment.post = post
    comment.user = current_user

    if comment.save
      flash[:notice] = I18n.t('msg.comment_saved')
    else
      flash[:error] = I18n.t('msg.comment_error')
    end

    redirect_to post_path(post)
  end

  def vote
    comment = Comment.find(params[:comment_id])
    vote = Vote.find_by(user: current_user, votable: comment)
    value = params[:value] == 'up' ? 1: -1

    begin
      if vote
        if not vote.update(value: value)
          raise VoteError
        end
      else
        vote = Vote.create(user: current_user, votable: comment, value: value)

        if not vote.id
          raise VoteError
        end
      end
      
      render json: { score: comment.score, value: vote.value }

    rescue VoteError
      render json: { error: I18n.t('msg.general_error') }
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    post = comment.post

    if comment.destroy
      flash[:notice] = I18n.t('msg.comment_deleted')
    else
      flash[:alert] = I18n.t('msg.general_error')
    end

    redirect_to post_path(post)
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end
end
