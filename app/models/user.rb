class User < ActiveRecord::Base
  SMS_CODE_LENGTH = 6
  ROLES = %w[admin moderator poster]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_create :set_defaults
  before_create :generate_sms_code
  after_create :send_sms_confirmation
  before_save :update_sms_code

  phony_normalize :phone, :default_country_code => 'US'

  validates :email, presence: true, uniqueness: true
  validates :phone, phony_plausible: true, uniqueness: true, presence: true

  def set_defaults
    if !self.role
      self.role = 'poster'
    end
  end

  def generate_sms_code
    self.sms_code = User.confirmation_code()
    self.sms_confirmed = false

    # Callback must return true
    return true
  end

  def send_sms_confirmation
    SendSmsConfirmationJob.perform_later(self)
  end

  def update_sms_code

    # Reverify when phone number is changed
    if !self.new_record? and self.changes()[:phone]
      self.generate_sms_code()
      self.send_sms_confirmation()
    end
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

  private

  # Generate an n-digit string of 0-9
  def self.confirmation_code
    return SMS_CODE_LENGTH.times.map {
      Random.rand(10)
    }.join()
  end
end
