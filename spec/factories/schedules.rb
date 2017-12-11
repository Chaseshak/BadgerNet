FactoryGirl.define do
  factory :schedule do
    association :user, factory: :athlete_user

    after(:create) do |schedule|
      3.times { create(:event, schedule: schedule) }
    end
  end
end
