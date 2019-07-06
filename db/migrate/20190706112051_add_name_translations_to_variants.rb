class AddNameTranslationsToVariants < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        Variant.add_translation_fields! name: :string
      end

      dir.down do
        remove_column :variant_translations, :name
      end
    end
  end
end
