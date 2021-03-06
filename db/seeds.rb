# 50.times do
#   Project.create! title: Faker::Company.name,
#                   description: Faker::ChuckNorris.fact(3)
#                   due_date: Faker::Time.between(DateTime.now, DateTime.now + 100)
# end

User.create(first_name: "Paul", last_name: "Lam", email: "paullam007@gmail.com", password: "p", is_admin: true)

User.create(first_name: "John", last_name: "Doe", email: "johndoe@gmail.com", password: "j")

User.create(first_name: "Tofu", last_name: "Tofu", email: "tofu@gmail.com", password: "t")

User.create(first_name: "Panda", last_name: "Panda", email: "panda@gmail.com", password: "p")

User.all.each do |user|
  30.times do
      user.projects.create(title: Faker::Company.name, description: Faker::Hacker.say_something_smart + Faker::Hipster.sentence(3), due_date: Faker::Date.forward(500))
      project_user = User.all.map(&:id).sample
    end
  end

Project.all.each do |project|
  3.times do
    project.discussions.create(title: Faker::Commerce.product_name, body: Faker::Lorem.paragraph)

  end
end

Discussion.all.each do |discussion|
  3.times do
    comment_user = User.all.map(&:id).sample
    discussion.comments.create(body: Faker::Lorem.paragraph(2))
  end
  discussion.user_id = 1 + rand(4); discussion.save
end

Comment.all.each do |comment|
  comment.user_id = 1 + rand(4); comment.save
end

30.times do
  Tag.create title: Faker::Hacker.adjective
end

Project.all.each do |project|
  2.times do
    project.tasks.create(title: Faker::Commerce.product_name)
  end
end

Task.all.each do |task|
  task.user_id = 1 + rand(4); task.save
end
