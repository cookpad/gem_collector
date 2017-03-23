FactoryGirl.define do
  factory :latest_gem_version, class: GemCollector::LatestGemVersion do
    sequence(:gem_name) {|n| "gem#{n}" }
    sequence(:version)  {|n| "0.0.#{n}" }
  end
end
