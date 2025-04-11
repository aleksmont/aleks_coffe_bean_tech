class CreateUserSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :user_sessions do |t|
      t.datetime :logged_at
      t.boolean :revoked, default: false

      t.string geolocation
      # informações de geolocalização
      # do IP do cliente (cidade, região e país) e um botão de logout.

      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
