class Article < ApplicationRecord
  enum status: { draft: 0, published: 1 }, _prefix: :status
  belongs_to :user

  has_many :article_likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :status, presence: true
  validates :title, presence: true
  validates :body, presence: true
end

# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  status     :integer
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_status   (status)
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
