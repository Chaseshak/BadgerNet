FactoryGirl.define do
  factory :scope do
    resource 'Document'
    resource_id 1
    association :role
  end
end
