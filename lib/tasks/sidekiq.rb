require 'sidekiq/api'

desc 'Clear all Sidekiq queues'
task :clear_sidekiq do
  Sidekiq::Queue.new.clear
  Sidekiq::RetrySet.new.clear
end
