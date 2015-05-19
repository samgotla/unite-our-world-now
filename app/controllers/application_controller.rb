class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # TODO: remove me!
  if Rails.env.production?
    http_basic_authenticate_with name: ENV['AUTH_USER'], password: ENV['AUTH_PASS']
  end
end
