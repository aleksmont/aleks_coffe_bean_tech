class CreateUserSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :user_sessions do |t|
      t.datetime :logged_at
      t.boolean :revoked, default: false
      t.string :city
      t.string :state
      t.string :country
      t.timestamps

      t.references :user, foreign_key: true
    end
  end
end
