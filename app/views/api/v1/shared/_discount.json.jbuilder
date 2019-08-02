json.extract! discount, :id, :merchant_id, :product_id, :percentage, :starts_at, :ends_at, :created_at, :updated_at

json.merchant_name discount.merchant.full_name
json.product_name discount.product.name
json.product_name_en discount.product.name_en
json.product_name_ar discount.product.name_ar

json.product do
  json.partial! 'api/v1/shared/product', product: discount.product
  json.variants do
    json.array! discount.product.variants, partial: 'api/v1/shared/variant', as: :variant 
  end
end
