require "rubygems/remote_fetcher"

class GemCollector::UpdateLatestGemVersions
  def run
    specs = fetch_specs
    gem_versions = take_latest_versions(specs)
    GemCollector::LatestGemVersion.import(
      [:gem_name, :version],
      gem_versions,
      on_duplicate_key_update: { conflict_target: [:gem_name], columns: [:version] }
    )
  end

  private

    # [
    #   [name, latest_version(or nil)],
    #   ...
    # ]
    def take_latest_versions(specs)
      specs.group_by(&:first).map { |name, spec|
        # spec: [gem_name, Gem::Version, platform]
        # XXX: platform is fixed to "ruby"
        max_version_spec = spec.select{|a| a[2] == "ruby" }.max_by{|a| a[1] }
        [
          name,
          max_version_spec && max_version_spec[1].version
        ]
      }
    end

    # XXX: How about prerelease_specs?
    def fetch_specs
      path = "https://rubygems.org/specs.#{Gem.marshal_version}.gz"
      data = Gem::RemoteFetcher.fetcher.fetch_path(path)
      Marshal.load(data)
    end
end
