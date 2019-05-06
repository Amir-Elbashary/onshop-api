class CreateVariantTranslations < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        Variant.create_translation_table!({
          color: :string,
          size: :string
        }, {
          migrate_data: true
        })
      end

      dir.down do
        Variant.drop_translation_table! migrate_data: true
      end
    end
  end
end
