module GemCollector::GemVersionValidationFilter
  def self.before(controller)
    [controller.params[:from_version], controller.params[:to_version]].each do |v|
      controller.render status: 400, plain: "Invalid version string: #{v}" unless valid_version?(v)
    end
  end

  def self.valid_version?(v)
    begin
      ::Gem::Version.new(v)
      true
    rescue ArgumentError
      false
    end
  end
end
