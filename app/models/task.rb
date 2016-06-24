class Task < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  validates :title, presence: true,
                    uniqueness: true
  def self.mark(task)
    if task.mark == "Undone"
      Task.update(task, :mark => "Done")
    else
      Task.update(task, :mark => "Undone")
    end
  end

end
