class CreateAppSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :app_settings do |t|
      t.string :name
      t.text :description
      t.string :keywords, array: true
      t.string :email
      t.string :logo

      t.timestamps
    end
  end
end
