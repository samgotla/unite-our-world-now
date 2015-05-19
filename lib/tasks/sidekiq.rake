require 'sidekiq/api'

namespace :sidekiq do
  desc 'Clear all Sidekiq queues'
  task :clear do
    puts 'Clearing Sidekiq queues'
    puts 'Default: %d' % Sidekiq::Queue.new.size
    puts 'Retry: %d' % Sidekiq::RetrySet.new.size
    
    Sidekiq::Queue.new.clear
    Sidekiq::RetrySet.new.clear
  end
end
