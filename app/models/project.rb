class Project < ActiveRecord::Base
  has_many :discussions, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :users, through: :favourites
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :teams, dependent: :nullify
  has_many :team_users, through: :teams, source: :user
  belongs_to :user
  validates :title, presence: true,
                    uniqueness: true
  validates :due_date, presence: true
  validate :due_date_greater_than_today

  def favourited_by?(user)
    # favourites.find_by_user_id user
    favourites.exists?(user: user)
  end

  def favourite_for(user)
    favourites.find_by_user_id user
  end

  private

  def due_date_greater_than_today
    if due_date
      if due_date < Date.today
        errors.add(:due_date, "Due date needs to be after today")
      end
    else
      errors.add(:due_date, "Due date required.")
    end
  end

end
