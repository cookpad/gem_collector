FactoryGirl.define do
  factory :repository_gem, class: GemCollector::RepositoryGem do
    sequence(:name) {|n| "gem#{n}" }
    sequence(:version) {|n| "0.0.#{n}" }
    path 'Gemfile.lock'
    repository_id { create(:repository).id }
  end
end
