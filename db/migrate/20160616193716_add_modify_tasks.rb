class AddModifyTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :mark, :string, :default => "Undone"
  end
end
