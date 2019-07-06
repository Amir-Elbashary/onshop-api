class AddNameToVariants < ActiveRecord::Migration[5.2]
  def change
    add_column :variants, :name, :string
  end
end
