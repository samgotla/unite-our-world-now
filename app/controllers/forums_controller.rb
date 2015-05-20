class ForumsController < ApplicationController
  before_action :authenticate_user!

  check_authorization
  load_and_authorize_resource

  def index
    render 'index', locals: { forums: Forum.all }
  end
end
