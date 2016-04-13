set :environment, "production"
set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}


every 1.day do
  rake 'run_daily_job'
end