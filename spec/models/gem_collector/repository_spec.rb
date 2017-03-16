require 'rails_helper'

RSpec.describe GemCollector::Repository do
  describe '.find_by_dependent_gem' do
    let(:gem_name) { 'activesupport' }

    before do
      %w[5.1.0 5.0.0.1 5.0.0 4.2.7 4.2.7.1].each do |v|
        FactoryGirl.create(:repository_gem, name: gem_name, version: v)
      end
      FactoryGirl.create(:repository_gem, name: 'dummy')
    end

    it 'does not care version without version specification' do
      expect(described_class.find_by_dependent_gem(gem_name).size).to eq(5)
    end

    it 'ignores non-version-number chars' do
      FactoryGirl.create(:repository_gem, name: gem_name, version: '5.0.0.beta3')
      expect(described_class.find_by_dependent_gem(gem_name).size).to eq(6)
    end

    it 'returns matched repositories with "from_version" specification' do
      repos = described_class.find_by_dependent_gem(gem_name, from_version: '5.0.0.1')
      expect(repos.map(&:gem_version)).to contain_exactly(*%w[5.0.0.1 5.1.0])
    end

    it 'returns matched repositories with "to_version" specification' do
      repos = described_class.find_by_dependent_gem(gem_name, to_version: '5.0.0')
      expect(repos.map(&:gem_version)).to contain_exactly(*%w[4.2.7 4.2.7.1])
    end

    it 'returns matched repositories with both "from_version" and "to_version" specification' do
      repos = described_class.find_by_dependent_gem(gem_name, from_version: '4.2.7', to_version: '5.1.0')
      expect(repos.map(&:gem_version)).to contain_exactly(*%w[4.2.7 4.2.7.1 5.0.0 5.0.0.1])
    end
  end
end
