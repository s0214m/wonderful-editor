class Api::V1::ArticlePreviewSerializer < ActiveModel::Serializer
  attributes :id, :title, :updated_at

  belongs_to :user, serializer: Api::V1::UserSerializer

  has_many :article_likes
  has_many :comments
end
