alias Blog.{Repo, User, Post, Comment}

john = Repo.insert!(%User{name: "John"})
jane = Repo.insert!(%User{name: "Jane"})
jim = Repo.insert!(%User{name: "Jim"})

post_1 = Repo.insert!(%Post{title: "Elixir is Awsome", content: "Elixir is awsome", posted_at: DateTime.utc_now(), user_id: john.id})
post_2 = Repo.insert!(%Post{title: "GraphQL Rocks", content: "GraphQL rocks", posted_at: DateTime.utc_now(), user_id: jane.id})
post_3 = Repo.insert!(%Post{title: "Le Tote ❤️  Elixir", content: "Le Tote is proudly powered by Elixir", posted_at: DateTime.utc_now(), user_id: john.id})

Repo.insert!(%Comment{content: "Definitely", post_id: post_1.id, user_id: jim.id, posted_at: DateTime.utc_now()})
Repo.insert!(%Comment{content: "Phoenix is better than Rails", post_id: post_1.id, user_id: jim.id, posted_at: DateTime.utc_now()})
Repo.insert!(%Comment{content: "PHP is the best", post_id: post_1.id, user_id: jane.id, posted_at: DateTime.utc_now()})
Repo.insert!(%Comment{content: "我愛狗浪", post_id: post_1.id, user_id: jane.id, posted_at: DateTime.utc_now()})
Repo.insert!(%Comment{content: "Build GraphQL APIs with Absinthe is a fantastic", post_id: post_2.id, user_id: john.id, posted_at: DateTime.utc_now()})
