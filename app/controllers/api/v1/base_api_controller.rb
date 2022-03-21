class Api::V1::BaseApiController < ApplicationController
  helper_method :current_api_v1_user, :api_v1_user_signed_in?, :authenticate_api_v1_user!
end
