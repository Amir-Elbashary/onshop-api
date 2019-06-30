class AddDefaultEntryInAppSettings < ActiveRecord::Migration[5.2]
  def change
    AppSetting.create(name_en: 'My Shop')
  end
end
