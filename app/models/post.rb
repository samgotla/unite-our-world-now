class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :forum
  has_many :comments, -> { order 'updated_at desc' }, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  validates :subject, presence: true
  validates :body, presence: true
  validates :forum_id, presence: true
  validates :user_id, presence: true

  def score
    return self.votes.sum(:value)
  end

  def vote_class(user, vote_type)
    vote = self.votes.find_by(user: user)

    if vote
      if vote_type == :up and vote.value == 1
        return 'voted'
      elsif vote_type == :down and vote.value == -1
        return 'voted'
      end
    end

    return ''
  end
end
