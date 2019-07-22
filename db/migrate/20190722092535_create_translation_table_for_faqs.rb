class CreateTranslationTableForFaqs < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        Faq.create_translation_table!({
          question: :text,
          answer: :text
        }, {
          migrate_data: true
        })
      end

      dir.down do
        Faq.drop_translation_table! migrate_data: true
      end
    end
  end
end
