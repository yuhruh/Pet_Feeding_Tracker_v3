class AddTimezoneUsernameToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :username, :string
    add_column :users, :timezone, :string
  end
end
