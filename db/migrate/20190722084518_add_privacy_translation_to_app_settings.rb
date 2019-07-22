class AddPrivacyTranslationToAppSettings < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        AppSetting.add_translation_fields! privacy: :text
      end

      dir.down do
        remove_column :app_setting_translations, :privacy
      end
    end
  end
end
