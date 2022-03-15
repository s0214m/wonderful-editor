# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text                       presence: true
#  title      :string                     presence: ture
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null  user must be exist
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Article, type: :model do
  it  do
  end
end
