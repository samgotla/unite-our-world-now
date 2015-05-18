class SendSmsConfirmationJob < ActiveJob::Base
  queue_as :default

  @@twilio_client = Twilio::REST::Client.new(
    ENV['TWILIO_ACCOUNT_SID'],
    ENV['TWILIO_AUTH_TOKEN']
  )

  def perform(user)
    body = SendSmsConfirmationJob.sms_body(user.sms_code)

    sms = @@twilio_client.messages.create(
      from: ENV['TWILIO_FROM'],
      to: user.phone,
      body: body
    )

    logger.debug sms.body
  end

  private
  def self.sms_body(code)
    return ActionController::Base.new().render_to_string(
             file: 'templates/sms_confirmation',
             locals: { code: code }
           )
  end
end
