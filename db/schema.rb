# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_17_084340) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "authentication_token"
    t.string "first_name"
    t.string "last_name"
    t.string "avatar"
    t.integer "gender", default: 0
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["gender"], name: "index_admins_on_gender"
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "app_setting_translations", force: :cascade do |t|
    t.integer "app_setting_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.text "description"
    t.text "privacy"
    t.index ["app_setting_id"], name: "index_app_setting_translations_on_app_setting_id"
    t.index ["locale"], name: "index_app_setting_translations_on_locale"
  end

  create_table "app_settings", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "keywords", array: true
    t.string "email"
    t.string "logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "privacy"
  end

  create_table "app_tokens", force: :cascade do |t|
    t.string "title"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "carts", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "state", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 1
    t.index ["state"], name: "index_carts_on_state"
    t.index ["status"], name: "index_carts_on_status"
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "image"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_categories_on_parent_id"
  end

  create_table "category_translations", force: :cascade do |t|
    t.integer "category_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["category_id"], name: "index_category_translations_on_category_id"
    t.index ["locale"], name: "index_category_translations_on_locale"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "user_name"
    t.string "email"
    t.string "phone_number"
    t.text "message"
    t.integer "status", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_contacts_on_status"
  end

  create_table "coupons", force: :cascade do |t|
    t.integer "percentage"
    t.string "code"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "discounts", force: :cascade do |t|
    t.bigint "merchant_id"
    t.bigint "product_id"
    t.integer "percentage"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["merchant_id"], name: "index_discounts_on_merchant_id"
    t.index ["product_id"], name: "index_discounts_on_product_id"
  end

  create_table "faq_translations", force: :cascade do |t|
    t.integer "faq_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "question"
    t.text "answer"
    t.index ["faq_id"], name: "index_faq_translations_on_faq_id"
    t.index ["locale"], name: "index_faq_translations_on_locale"
  end

  create_table "faqs", force: :cascade do |t|
    t.text "question"
    t.text "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favourites", force: :cascade do |t|
    t.bigint "user_id"
    t.string "favourited_type"
    t.bigint "favourited_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["favourited_type", "favourited_id"], name: "index_favourites_on_favourited_type_and_favourited_id"
    t.index ["user_id"], name: "index_favourites_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.bigint "cart_id"
    t.bigint "variant_id"
    t.integer "quantity", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_items_on_cart_id"
    t.index ["variant_id"], name: "index_items_on_variant_id"
  end

  create_table "logins", force: :cascade do |t|
    t.bigint "admin_id"
    t.bigint "merchant_id"
    t.bigint "user_id"
    t.string "token"
    t.string "ip_address"
    t.string "agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_logins_on_admin_id"
    t.index ["merchant_id"], name: "index_logins_on_merchant_id"
    t.index ["user_id"], name: "index_logins_on_user_id"
  end

  create_table "merchants", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "authentication_token"
    t.string "first_name"
    t.string "last_name"
    t.string "avatar"
    t.integer "gender", default: 0
    t.string "phone_number"
    t.index ["email"], name: "index_merchants_on_email", unique: true
    t.index ["gender"], name: "index_merchants_on_gender"
    t.index ["reset_password_token"], name: "index_merchants_on_reset_password_token", unique: true
  end

  create_table "offers", force: :cascade do |t|
    t.bigint "category_id"
    t.integer "percentage"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_offers_on_category_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "cart_id"
    t.integer "order_number"
    t.integer "total_items", default: 0
    t.decimal "total_price", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_orders_on_cart_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "product_translations", force: :cascade do |t|
    t.integer "product_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.text "description"
    t.index ["locale"], name: "index_product_translations_on_locale"
    t.index ["product_id"], name: "index_product_translations_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "merchant_id"
    t.bigint "category_id"
    t.string "name"
    t.text "description"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["merchant_id"], name: "index_products_on_merchant_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "product_id"
    t.text "review"
    t.integer "rating", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_reviews_on_product_id"
    t.index ["user_id", "product_id"], name: "index_reviews_on_user_id_and_product_id", unique: true
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "email"
    t.integer "status", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_subscriptions_on_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "authentication_token"
    t.string "first_name"
    t.string "last_name"
    t.string "avatar"
    t.string "shipping_address"
    t.integer "gender", default: 0
    t.string "country"
    t.string "city"
    t.string "region"
    t.string "phone_number"
    t.string "provider"
    t.string "uid"
    t.string "zip_code"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["gender"], name: "index_users_on_gender"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "variant_translations", force: :cascade do |t|
    t.integer "variant_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
    t.string "size"
    t.string "name"
    t.index ["locale"], name: "index_variant_translations_on_locale"
    t.index ["variant_id"], name: "index_variant_translations_on_variant_id"
  end

  create_table "variants", force: :cascade do |t|
    t.bigint "product_id"
    t.string "color"
    t.string "size"
    t.decimal "price", default: "0.0"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity", default: 0
    t.string "name"
    t.index ["product_id"], name: "index_variants_on_product_id"
  end

  add_foreign_key "carts", "users"
  add_foreign_key "discounts", "merchants"
  add_foreign_key "discounts", "products"
  add_foreign_key "favourites", "users"
  add_foreign_key "items", "carts"
  add_foreign_key "items", "variants"
  add_foreign_key "logins", "admins"
  add_foreign_key "logins", "merchants"
  add_foreign_key "logins", "users"
  add_foreign_key "offers", "categories"
  add_foreign_key "orders", "carts"
  add_foreign_key "orders", "users"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "merchants"
  add_foreign_key "reviews", "products"
  add_foreign_key "reviews", "users"
  add_foreign_key "variants", "products"
end
