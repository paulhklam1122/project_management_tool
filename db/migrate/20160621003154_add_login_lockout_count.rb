class AddLoginLockoutCount < ActiveRecord::Migration
  def change
    add_column :users, :login_lockout_count, :integer, default: 0
    add_column :users, :account_lockout, :boolean, default: false
  end
end
