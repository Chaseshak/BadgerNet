FactoryGirl.define do
  factory :event do
    name 'My Event'
    start_time '09:30:00'
    end_time '12:15:00'
    days [0, 1, 2, 3, 4, 5, 6].sample(1)
    association :schedule
  end
end
