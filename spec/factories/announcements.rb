FactoryGirl.define do
  factory :announcement do
    content 'This is a message!'
    title 'Hello'
    email false
    sms false

    factory :announcement_email do
      email true
    end

    factory :announcement_sms do
      sms true
    end

    factory :announcement_both do
      sms true
      email true
    end
  end
end
