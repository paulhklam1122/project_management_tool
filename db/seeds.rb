50.times do
  Project.create! title: Faker::Company.name,
                  description: Faker::Lorem.sentence,
                  due_date: Faker::Time.between(DateTime.now, DateTime.now + 100)
end
