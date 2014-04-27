FactoryGirl.define do
  factory :article do
    sequence(:title)   { |n| "Article #{n}" }
    sequence(:content) { |n| "Article #{n} content" }
  end

  factory :blog do
    sequence(:title) { |n| "Blog #{n}" }
  end

  factory :collection do
    sequence(:name)        { |n| "Collection #{n}" }
    sequence(:description) { |n| "Collection #{n} description" }
  end

  factory :comment do
    sequence(:author) { |n| "author of comment #{n}" }
    sequence(:body)   { |n| "Comment #{n}" }
    sequence(:email)  { |n| "commenter#{n}@gmail.com" }
  end

  factory :checkout do
  end

  factory :customer do
    sequence(:email)  { |n| "customer#{n}@gmail.com" }
  end

  factory :page do
    sequence(:title)   { |n| "Title #{n}" }
    sequence(:content) { |n| "Content #{n}" }
  end

  factory :product do
    sequence(:name)        { |n| "Example #{n}" }
    sequence(:description) { |n| "Example #{n} description" }
  end

  factory :product_image do
  end

  factory :shop do
    sequence(:name)      { |n| "Example#{n}" }
    sequence(:subdomain) { |n| "example#{n}" }
    sequence(:email)     { |n| "admin@example#{n}.com" }

    password 'password'
    password_salt BCrypt::Engine.generate_salt
    password_digest { BCrypt::Engine.hash_secret('password', password_salt) }
  end

  factory :theme do
    sequence(:name)      { |n| "Theme#{n}" }
  end
end