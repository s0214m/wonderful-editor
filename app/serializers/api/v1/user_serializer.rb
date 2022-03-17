class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email

  has_many :articles
  has_many :article_likes
  has_many :comments
end
