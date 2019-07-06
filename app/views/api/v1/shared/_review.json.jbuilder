json.extract! review, :id, :user_id, :product_id, :review, :rating, :created_at, :updated_at
json.user_name review.user.full_name
