# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Rate.create!(name: 'junior', amount: 50, description: "")
Rate.create!(name: 'intermediate', amount: 100, description: "")
Rate.create!(name: 'senior', amount: 150, description: "")

User.create!(first_name: 'Admin', last_name: 'Admin', email: 'admin@admin.com', password: '12345678', role: '0', rate_id: 1)