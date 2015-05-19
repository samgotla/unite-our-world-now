class User < ActiveRecord::Base
  SMS_CODE_LENGTH = 6
  ROLES = %w[admin moderator poster]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_create :set_defaults
  before_save :update_sms_code
  after_save :send_sms_confirmation

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

  private

  def send_sms_confirmation
    if self.changes()[:sms_code] or self.previous_changes()[:sms_code]
      logger.debug 'Queuing SMS to %s (code: %s)' % [ self.phone, self.sms_code ]

      SendSmsConfirmationJob.perform_later(self)
    end
  end

  def update_sms_code

    # Generate code on new record or when phone number is changed
    if self.new_record? or self.changes()[:phone]
      self.generate_sms_code()
    end
  end

  # Generate an n-digit string of 0-9
  def self.confirmation_code
    return SMS_CODE_LENGTH.times.map {
      Random.rand(10)
    }.join()
  end
end
