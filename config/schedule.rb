set :environment, "development"
set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}


every 1.day, :at => '12:01 am' do
  #runner Job.daily_report_aggregator_job Date.today.prev_day.prev_day, Date.today.prev_day
  rake 'run_daily_job'
end