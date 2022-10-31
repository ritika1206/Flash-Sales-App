set :output, "#{path}/log/cron.log"
set :environment, 'development'
 
every 1.days, at: '10:00 am' do
  rake 'deal:update_live_status'
end
