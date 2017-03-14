FactoryGirl.define do
  factory :user do
    sequence(:name) { |i| "Name #{i}" }
  end
end
