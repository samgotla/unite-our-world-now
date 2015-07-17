class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  has_many :votes, as: :votable

  validates :body, presence: true
  validates :post_id, presence: true
  validates :user_id, presence: true
end
