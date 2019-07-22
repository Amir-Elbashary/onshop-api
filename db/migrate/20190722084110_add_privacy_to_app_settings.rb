class AddPrivacyToAppSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :app_settings, :privacy, :text
  end
end
