class User < ActiveRecord::Base
  SMS_CODE_LENGTH = 6
  ROLES = %w[admin moderator poster]
  PHONE_SUB_REGEX = /[^\d+]/
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  before_create :set_defaults
  before_save :update_sms_code
  after_save :send_sms_confirmation
  before_validation :normalize_phone
  
  validates :email, presence: true, uniqueness: true
  validates :phone, uniqueness: true, presence: true, length: { minimum: 10 }

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

  def send_sms_confirmation(force=false)
    if should_send_sms? or force
      logger.debug 'Queuing SMS to %s (code: %s)' % [ self.phone, self.sms_code ]
      SendSmsConfirmationJob.perform_later(self)
    end
  end

  private

  def normalize_phone
    self.phone.gsub!(PHONE_SUB_REGEX, '') if self.phone
  end
  
  def update_sms_code
    
    # Generate code on new record or when phone number is changed
    if self.new_record? or self.phone_changed?
      self.generate_sms_code()
    end
  end

  def should_send_sms?
    
    # Create
    if self.id_changed? and !self.sms_confirmed
      return true
      
    # Update
    elsif self.sms_code_changed? and !self.sms_confirmed
      return true
    end
    
    return false
  end
  
  # Generate an n-digit string of 0-9
  def self.confirmation_code
    return SMS_CODE_LENGTH.times.map {
      Random.rand(10)
    }.join()
  end
end
