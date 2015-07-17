class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user_id, presence: true, numericality: true, uniqueness: {
              scope: [ :votable_id, :votable_type ]
            }
  validates :votable_id, presence: true, numericality: true
  validates :value, presence: true, numericality: true
  validates :votable_type, presence: true
end
