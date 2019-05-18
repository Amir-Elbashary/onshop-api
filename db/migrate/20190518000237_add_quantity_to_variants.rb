class AddQuantityToVariants < ActiveRecord::Migration[5.2]
  def change
    add_column :variants, :quantity, :integer, default: 0
  end
end
