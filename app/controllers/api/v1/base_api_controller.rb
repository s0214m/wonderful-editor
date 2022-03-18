class Api::V1::BaseApiController < ApplicationController
  before_action :current_user
  def current_user
    @current_user ||= User.first
  end
end
