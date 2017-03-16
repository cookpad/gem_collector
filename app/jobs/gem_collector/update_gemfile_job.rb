class GemCollector::UpdateGemfileJob < GemCollector::ApplicationJob
  def perform(repository_id)
    GemCollector::UpdateGemfile.new.run(GemCollector::Repository.find(repository_id))
  end
end
