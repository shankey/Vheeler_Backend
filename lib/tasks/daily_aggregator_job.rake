
desc 'run_daily_job'
task run_daily_job: :environment do
  Job.daily_report_aggregator_job Date.today.prev_day.prev_day, Date.today.prev_day
end