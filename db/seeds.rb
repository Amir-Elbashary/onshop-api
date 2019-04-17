# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.create(email: 'admin@onshop.com', password: 'AdminAdmin', password_confirmation: 'AdminAdmin', first_name: 'OnShop', last_name: 'Admin')
puts 'Created 1 Admin'
