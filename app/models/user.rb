class User < ActiveRecord::Base
  SMS_CODE_LENGTH = 6
  ROLES = %w[admin moderator poster]
  PHONE_SUB_REGEX = /[^\d+]/
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  before_create :set_defaults
  after_create :send_sms_confirmation
  before_validation :normalize_phone
  
  validates :email, presence: true, uniqueness: true
  validates :phone, uniqueness: true, presence: true, length: { minimum: 10 }
  validates :latitude, numericality: true, allow_blank: true
  validates :longitude, numericality: true, allow_blank: true
  validates :zip_code, numericality: { :only_integer => true }, allow_blank: true

  belongs_to :forum
  has_many :posts, -> { order 'updated_at desc' }
  has_many :approved_posts, -> {
    where(approved: true).order('updated_at desc')
  }, class: Post
  has_many :pending_posts, -> {
    where(approved: false).order('updated_at desc')
  }, class: Post
  has_many :comments, -> { order 'updated_at desc' }
  has_many :votes
  has_many :post_votes, -> { where(votable_type: 'Post') }, class: Vote
  has_many :comment_votes, -> { where(votable_type: 'Comment') }, class: Vote

  scope :pending, -> { where(sms_confirmed: false, role: 'poster') }

  def set_defaults
    if !self.role
      self.role = 'poster'
    end

    self.sms_code = User.confirmation_code()
    
    return true
  end

  def poster?
    return self.role == 'poster'
  end
  
  def moderator?
    return self.role == 'moderator'
  end
  
  def admin?
    return self.role == 'admin'
  end

  def send_sms_confirmation
    logger.debug 'Queuing SMS to %s (code: %s)' % [ self.phone, self.sms_code ]
    SendSmsConfirmationJob.perform_later(self)
  end

  def loc_json
    return { lat: self.latitude, lng: self.longitude }.to_json()
  end

  def all_forums
    rv = [ self.forum ]
    f = self.forum.parent

    while f
      rv << f
      f = f.parent
    end

    return rv
  end

  private

  def normalize_phone
    self.phone.gsub!(PHONE_SUB_REGEX, '') if self.phone
  end
  
  # Generate an n-digit string of 0-9
  def self.confirmation_code
    return SMS_CODE_LENGTH.times.map {
      Random.rand(10)
    }.join()
  end
end
