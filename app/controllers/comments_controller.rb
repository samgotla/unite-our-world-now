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

    redirect_to forum_post_path(post.forum, post.id)
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end
end
