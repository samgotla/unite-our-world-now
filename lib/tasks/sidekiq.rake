require 'sidekiq/api'

desc 'Clear all Sidekiq queues'
task :clear_sidekiq do
  puts 'Clearing Sidekiq queues'
  puts 'Default: %d' % Sidekiq::Queue.new.size
  puts 'Retry: %d' % Sidekiq::RetrySet.new.size

  Sidekiq::Queue.new.clear
  Sidekiq::RetrySet.new.clear
end
