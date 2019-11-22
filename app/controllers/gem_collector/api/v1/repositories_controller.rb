class GemCollector::Api::V1::RepositoriesController < ActionController::API
  def index
    render json: GemCollector::Repository.all.map(&:as_json)
  end

  def show
    repository = GemCollector::Repository.find(params[:id])
    render json: {
      gemfiles: repository.gems_with_version_point.group_by(&:path).map { |path, gems|
        {
          path: path,
          gems: gems.map { |gem|
            {
              name: gem.name,
              version: gem.version,
              version_point: gem.version_point,
            }
          },
        }
      },
    }
  end
end
