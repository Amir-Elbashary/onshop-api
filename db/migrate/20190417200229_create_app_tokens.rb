class CreateAppTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :app_tokens do |t|
      t.string :title
      t.string :token
      t.timestamps
    end
  end
end
