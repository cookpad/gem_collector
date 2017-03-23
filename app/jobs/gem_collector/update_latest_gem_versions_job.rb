class GemCollector::UpdateLatestGemVersionsJob < GemCollector::ApplicationJob
  def perform(*args)
    GemCollector::UpdateLatestGemVersions.new.run
  end
end
