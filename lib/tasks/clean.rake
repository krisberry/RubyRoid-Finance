desc 'Clean sidekiq'
task :clean_sidekiq => :environment do
  require 'sidekiq/api'
  puts "Cleaning sidekiq`s queries"
  Sidekiq::Queue.new('default').clear
  Sidekiq::Queue.new('mailers').clear
  Sidekiq::RetrySet.new.clear
  Sidekiq::ScheduledSet.new.clear
  Sidekiq::DeadSet.new.clear
  puts "Done"
end