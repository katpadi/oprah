# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



User.first_or_create(name: 'Kat Guest', email: 'guest@katpadi.ph', password: '12345678', role: 0)
user = User.first_or_create(name: 'Kat', email: 'user@katpadi.ph', password: '12345678', role: 1)
admin = User.first_or_create(name: 'Kat Admin', email: 'admin@katpadi.ph', password: '12345678', role: 2)

prizes = Prize.create([{ user: admin, name: 'DJI Mavic Pro', description: 'woah this is awesome' }, { user: user, name: 'Nintendo Switch', description: 'lollololol' }])

prizes.first.entries.create([{ comment: 'Pick me!', user: user }, { comment: 'Dibs!!!!', user: user }])
prizes.last.entries.create([{ comment: 'Coolcoolcool', user: user }])
