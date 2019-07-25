class CreateLogins < ActiveRecord::Migration[5.2]
  def change
    create_table :logins do |t|
      t.references :admin, foreign_key: true
      t.references :merchant, foreign_key: true
      t.references :user, foreign_key: true
      t.string :token
      t.string :ip_address
      t.string :agent
      t.timestamps
    end
  end
end
