FactoryBot.define do
  factory :classification, :class => MedusaRestClient::Classification do
    name { "class-1" }
    full_name { "classification 1" }
    description { "This is a classification" }
    parent_id { "" }
    lft { 1 }
    rgt { 1 }
  end
end
