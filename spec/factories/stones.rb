FactoryBot.define do
  factory :stone, :class => MedusaRestClient::Stone do
    sequence(:id)
    name { "stone-1" }
    stone_type { "hand specimen" }
    description { "This is a stone" }
    parent_id { "" }
#    association :place, factory: :place
#    association :box, factory: :box
#    association :physical_form, factory: :physical_form
#    association :classification, factory: :classification
    quantity { 1 }
    quantity_unit { "kg" }
  end
end