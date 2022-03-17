class Api::V1::ArticlePreviewSerializer < ActiveModel::Serializer
  attributes :id, :title, :updated_at

  belongs_to :user, serializer: Api::V1::UserSerializer #option (任意)

  has_many :article_likes
  has_many :comments
end
