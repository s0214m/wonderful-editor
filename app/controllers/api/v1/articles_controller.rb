class Api::V1::ArticlesController < Api::V1::BaseApiController
  before_action :set_article, only: [:update, :destroy]

  def index
    @articles = Article.all.order(updated_at: :desc)
    render json: @articles, each_serializer: Api::V1::ArticlePreviewSerializer
  end

  def show
    @article = Article.find(params[:id])
    render json: @article, serializer: Api::V1::ArticleSerializer
  end

  def create
    @article = current_user.articles.create!(article_params)
    render json: @article, serializer: Api::V1::ArticleSerializer
  end

  def update
    @article.update!(article_params)
    render json: @article, serializer: Api::V1::ArticleSerializer
  end

  def destroy
    @article.destroy!
    render json: @article, serialezer: Api::V1::ArticleSerializer
  end

  private

    def set_article
      @article = current_user.articles.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :body)
    end
end
