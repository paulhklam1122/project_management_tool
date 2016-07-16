class AddGithubOauthFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :github_token, :string
    add_column :users, :github_secret, :string
    add_column :users, :github_raw_data, :text

    add_index :users, [:uid, :provider]
  end
end
