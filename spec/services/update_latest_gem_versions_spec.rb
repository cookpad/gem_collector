require 'rails_helper'

RSpec.describe GemCollector::UpdateLatestGemVersions do
  describe "#run" do
    subject { @service.run }

    before {
      @service = GemCollector::UpdateLatestGemVersions.new
      allow(@service).to receive(:fetch_specs) {
        [
          ["gem_a", Gem::Version.new("0.0.1"), "ruby"],
          ["gem_a", Gem::Version.new("0.0.2"), "ruby"],
          ["gem_b", Gem::Version.new("0.1.0"), "ruby"],
          ["gem_c", Gem::Version.new("1.0.0"), "ruby"],
        ]
      }
    }

    context "table is empty" do
      it "insert successfully" do
        subject
        actual_versions = GemCollector::LatestGemVersion.where(gem_name: %w(gem_a gem_b gem_c)).pluck(:version)
        expect(actual_versions).to eq ["0.0.2", "0.1.0", "1.0.0"]
      end
    end

    context "table has records" do
      before {
        FactoryGirl.create(:latest_gem_version, gem_name: "gem_c", version: "0.0.1")
      }
      it "upsert successfully" do
        subject
        actual_version = GemCollector::LatestGemVersion.find_by(gem_name: "gem_c").version
        expect(actual_version).to eq "1.0.0"
      end
    end
  end
end
