FactoryGirl.define do
  factory :repository, class: GemCollector::Repository do
    sequence(:repository_id) {|n| n }
    sequence(:site) {|n| "site#{n}" }
    sequence(:full_name) {|n| "cookpad/repo#{n}" }
    ssh_url { "git@example.com:#{full_name}.git" }
  end
end
