class Project < ActiveRecord::Base
  has_many :discussions, dependent: :destroy
  has_many :tasks, dependent: :destroy
  belongs_to :user
  validates :title, presence: true,
                    uniqueness: true
  # validate :due_date_greater_than_today

  private

  # def due_date_greater_than_today
  #   if due_date < Date.today
  #     errors.add(:due_date, "Due date needs to be after today")
  #   end
  # end
end
