class AddDefaultsToVariants < ActiveRecord::Migration[5.2]
  def change
    change_column_default :variants, :price, 0
    change_column_default :variants, :discount, 0
  end
end
