namespace :users do
  desc 'Generate users'
  task generate: :environment do
    User.destroy_all()

    FactoryGirl.create(:user,
                       email: 'admin@example.com',
                       role: 'admin',
                       sms_confirmed: true
                      )
    
    FactoryGirl.create(:user,
                       email: 'moderator@example.com',
                       role: 'mosderator',
                       sms_confirmed: true
                      )
    
    FactoryGirl.create(:user,
                       email: 'confirmed_user@example.com',
                       role: 'poster',
                       sms_confirmed: true
                      )
    
    FactoryGirl.create(:user,
                       email: 'unconfirmed_user@example.com',
                       role: 'poster'
                      )

    User.update_all(sms_code: '123456')
  end
end
