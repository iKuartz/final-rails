user1 = User.create(name:"Ivan")
user2 = User.create(name:"Saadat")
feats_hot1 = Feature.create(room: 20, pool: true, bar: true, air_conditioning: true, tv: false, gym: false)
feats_hot2 = Feature.create(room: 16, pool: false, bar: false, air_conditioning: true, tv: true, gym: true)
address_hot1 = Address.create(country: "Brazil", state: "Rio de Janeiro", city: "Penedo", neighbourhood: "Centro", street: "Avenida das três cachoeiras", number: 31)
address_hot2 = Address.create(country: "Pakistan", state: "Gilgid", city: "Skardu", neighbourhood: "Downtown", street: "54th Street", number: 11)
hotel1 = Hotel.new(user_id: user1.id, name: "Chocolate house Hotel", feature_id: feats_hot1.id, address_id: address_hot1.id, description: "An unforgattable experience for the lovers of chocolate all around the world!" )
hotel1.image.attach(io: File.open(Rails.root.join("app/assets/images/hotel1.jpg")), filename: 'hotel1.jpg')
hotel1.save
hotel2 = Hotel.new(user_id: user2.id, name: "Peaceful Mountain Hotel", feature_id: feats_hot2.id, address_id: address_hot2.id, description: "Feel the soothing breeze of the mountains and relax in the jewel of Skardu!" )
hotel2.image.attach(io: File.open(Rails.root.join("app/assets/images/hotel2.jpg")), filename: 'hotel2.jpg')
hotel2.save
hotel3 = Hotel.new(user_id: user1.id, name: "Great Plains Resort", feature_id: feats_hot1.id, address_id: address_hot1.id, description: "Let the wind of the plains feel your heart with soothe in this 5 stars resort." )
hotel3.image.attach(io: File.open(Rails.root.join("app/assets/images/hotel3.jpg")), filename: 'hotel3.jpg')
hotel3.save
hotel4 = Hotel.new(user_id: user2.id, name: "Canion Wonder", feature_id: feats_hot2.id, address_id: address_hot2.id, description: "In front of the world's greatest canyon, this hotel is for the wild adventurers." )
hotel4.image.attach(io: File.open(Rails.root.join("app/assets/images/hotel4.jpg")), filename: 'hotel4.jpg')
hotel4.save
hotel5 = Hotel.new(user_id: user1.id, name: "Say Cheese Hotel", feature_id: feats_hot1.id, address_id: address_hot1.id, description: "For those who like cheese, this hotel is also a famous cheese factory." )
hotel5.image.attach(io: File.open(Rails.root.join("app/assets/images/hotel5.webp")), filename: 'hotel5.webp')
hotel5.save
hotel6 = Hotel.new(user_id: user2.id, name: "Lovely huts Hotel", feature_id: feats_hot2.id, address_id: address_hot2.id, description: "This is a charming retreat from the noisy and busy life of the city." )
hotel6.image.attach(io: File.open(Rails.root.join("app/assets/images/hotel6.jpg")), filename: 'hotel6.jpg')
hotel6.save
reservation1 = Reservation.create(user_id: user1.id, hotel_id: hotel1.id, reserved_rooms: 10, date_from: "2022-08-08", date_to: "2022-08-10")
availability1 = AvailableOnDate.create(date:"2022-08-08", rooms_occopied:10, rooms_free:10, hotel_id:hotel1.id, available:true)
availability2 = AvailableOnDate.create(date:"2022-08-09", rooms_occopied:10, rooms_free:10, hotel_id:hotel1.id, available:true)
availability1 = AvailableOnDate.create(date:"2022-08-10", rooms_occopied:10, rooms_free:10, hotel_id:hotel1.id, available:true)
