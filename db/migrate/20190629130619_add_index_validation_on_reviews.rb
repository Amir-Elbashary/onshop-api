class AddIndexValidationOnReviews < ActiveRecord::Migration[5.2]
  def change
    add_index :reviews, %i[user_id product_id], unique: true
  end
end
