class DailyDiscussionsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    @discussions = Discussion.select("discussions.id, created_at").
                         joins(:created_at).
                         group("discussions.id").
                         order("time_created DESC").
                         where("discussions.created_at >= ? AND discussions.created_at <= ?",
                                Time.now(2_days_ago),
                                Time.now(1_days_ago).
                         limit(10)
    AdminMailer.send_daily_report(@discussions).deliver_now
  end
end
