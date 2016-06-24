class Comment < ActiveRecord::Base
  belongs_to :discussion
  belongs_to :user
  validates :body, presence: true

  # def should_notify?
  #   discussion.user != self.user
  # end
end
