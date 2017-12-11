FactoryGirl.define do
  factory :role do
    sequence(:name) { |n| "test_role_#{n}" }
    archived false

    factory :athlete_role do
      name :athlete
    end

    factory :coach_role do
      name :coach
    end
  end
end
