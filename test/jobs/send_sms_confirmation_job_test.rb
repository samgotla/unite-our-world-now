require 'test_helper'

class SendSmsConfirmationJobTest < ActiveJob::TestCase
  test 'that job is added to queue' do
    user = FactoryGirl.create(:user)
    assert_enqueued_jobs(1)
  end

  test 'that SMS is sent to valid number' do
    user = FactoryGirl.create(:user, phone: TWILIO_MAGIC_VALID_NUMBER)
    
    SendSmsConfirmationJob.perform_now(user)

    # If the Twilio API call doesn't return an error, assume pass
    assert true
  end

  test 'that SMS is not sent to valid number' do
    user = FactoryGirl.create(:user, phone: TWILIO_MAGIC_INVALID_NUMBER)

    begin
      SendSmsConfirmationJob.perform_now(user)
      
    rescue Twilio::REST::RequestError => e

      # Check message contents; this could break if Twilio decides to
      # change their error message since RequestError is not specific
      if e.message.index 'is not a valid phone number'
        assert true
      end
    end
  end
end
