# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



User.create(name: 'Kat Guest', email: 'guest@katpadi.ph', password: '12345678', role: :guest)
user = User.create(name: 'Kat', email: 'user@katpadi.ph', password: '12345678', role: :user)
admin = User.create(name: 'Kat Admin', email: 'admin@katpadi.ph', password: '12345678', role: :admin)

prizes = Prize.create([{ user: admin, name: 'DJI Mavic Pro', description: 'woah this is awesome' }, { user: user, name: 'Nintendo Switch', description: 'lollololol' }])
prize = prizes.first
prize.entries.create([{ comment: 'Pick me!', user: user }, { comment: 'Ako na lang. ako na lang ulit', user: user }, { comment: 'Yepppp!!', user: user }, { comment: 'Yeaaaaaaaaa!', user: user }])
prizes.last.entries.create([{ comment: 'Coolcoolcool', user: user }])
WinnerProcessor.new(prize.entries, prize, admin).process
