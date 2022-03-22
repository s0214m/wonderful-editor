class Api::V1::Articles::DraftsController < Api::V1::BaseApiController
  before_action :authenticate_user!, only: [:index, :show]

  def index
    articles = current_user.articles.where(status: "draft").order(updated_at: :desc)
    render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
  end

  def show
    article = current_user.articles.where(status: "dfart").find(params[:id])
    render json: article, serializer: Api::V1::ArticleSerializer
  end
end
