class GemCollector::GemNewsController < GemCollector::ApplicationController
  before_action GemCollector::GemVersionValidationFilter
  before_action :validate_body, only: :create

  def new
  end

  def create
    repositories = GemCollector::Repository.find_by_dependent_gem(params[:name], from_version: params[:from_version], to_version: params[:to_version])
    begin
      GemCollector::CreateGemNews.new(request.origin, *params.permit(:name, :title, :body, :from_version, :to_version).values).run(repositories)
      flash[:notice] = 'Issues were created successfully'
    rescue GemCollector::CreateGemNews::Error => e
      flash[:error] = e.message
    end
    redirect_to repository_gem_path(params.permit(:name, :from_version, :to_version))
  end

  private def validate_body
    render status: 400, plain: 'Empty body given' if params[:body].blank?
  end
end
