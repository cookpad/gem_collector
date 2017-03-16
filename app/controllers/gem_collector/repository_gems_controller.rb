class GemCollector::RepositoryGemsController < GemCollector::ApplicationController
  before_action GemCollector::GemVersionValidationFilter, only: :show

  def index
    count_col = 'count(repository_id)'
    order_by = [:name]
    if order_by_popularity?
      order_by.unshift("#{count_col} desc")
    end
    @gems = GemCollector::RepositoryGem.order(order_by).group(:name).pluck(:name, count_col)
  end

  def show
    @gem_name = params[:name]
    @repositories = GemCollector::Repository.find_by_dependent_gem(@gem_name, from_version: params[:from_version], to_version: params[:to_version])
  end

  private def order_by_popularity?
    params[:order] == 'popularity'
  end
  helper_method :order_by_popularity?
end
