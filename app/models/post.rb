class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :forum

  validates :subject, presence: true
  validates :body, presence: true
  validates :forum_id, presence: true
  validates :user_id, presence: true
end
