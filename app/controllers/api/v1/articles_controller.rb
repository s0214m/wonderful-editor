class Api::V1::ArticlesController < Api::V1::BaseApiController
  def index
    articles = Article.all.order(updated_at: :desc)
    render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
  end

  def show
    current_user
    article = Article.find(params[:id])
    render json: article, serializer: Api::V1::ArticleSerializer
  end

  def create
    article = current_user.articles.create!(article_params)
    render json: article, serializer: Api::V1::ArticleSerializer
  end

  private

    def article_params
      params.require(:article).permit(:title, :body)
    end
end
