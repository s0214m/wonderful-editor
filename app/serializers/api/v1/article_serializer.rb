class Api::V1::ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :updated_at, :status

  belongs_to :user, serializer: Api::V1::UserSerializer

  has_many :comments
  has_many :article_likes
end
