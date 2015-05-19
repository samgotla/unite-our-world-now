class ForumsController < ApplicationController
  before_action :authenticate_user!

  def index
    render 'index', locals: { forums: Forum.all }
  end
end
