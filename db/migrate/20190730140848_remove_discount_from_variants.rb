class RemoveDiscountFromVariants < ActiveRecord::Migration[5.2]
  def change
    remove_column :variants, :discount
  end
end
