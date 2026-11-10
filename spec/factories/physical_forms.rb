FactoryBot.define do
  factory :physical_form, :class => MedusaRestClient::PhysicalForm do
    name { "phsycal form" }
    description { "this is a form" }
  end
end