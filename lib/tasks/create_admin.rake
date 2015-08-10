namespace :users do
  desc 'Create admin user'
  task create_admin: :environment do
    admin = FactoryGirl.create(:user,
                               email: 'admin@unite-our-world-now.com',
                               password: Faker::Internet.password,
                               role: 'admin',
                               sms_confirmed: true
                              )

    puts 'Admin email: %s' % admin.email
    puts 'Admin password: %s' % admin.password
  end
end
