# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    sequence(:name) { |i| "Name #{i}" }
  end
end
