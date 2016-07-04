class DailyTasksJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
  #   @discussions = Discussion.select("tasks.id, created_at").
  #                        joins(:created_at).
  #                        group("tasks.id").
  #                        order("time_created DESC").
  #                        where("tasks.created_at >= ? AND tasks.created_at <= ?",
  #                               Time.now(2_days_ago,
  #                               Time.now(1_days_ago).
  #                        limit(10)
  #   AdminMailer.send_daily_report(@tasks).deliver_now
  end
end
