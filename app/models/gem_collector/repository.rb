class GemCollector::Repository < GemCollector::ApplicationRecord
  has_many :repository_gems, dependent: :delete_all

  def url(path = nil)
    u = "https://#{site}/#{full_name}"
    if path
      "#{u}/blob/master/#{path}"
    else
      u
    end
  end

  def canonical_name
    "#{site}/#{full_name}"
  end

  POINTS_FOR_GEMS_SQL = <<-SQL.strip_heredoc
    select
      gems.repository_id, gems.path, gems.name, gems.version
      , cume_dist() over (partition by gems.name order by regexp_split_to_array(regexp_replace(version, '\.[^0-9.]+$', ''), '[^0-9]+') :: bigint[]) as version_point
    from
      #{GemCollector::RepositoryGem.table_name} gems
  SQL

  def gems_with_version_point
    GemCollector::RepositoryGem.find_by_sql([<<-SQL.strip_heredoc, repository_id: id])
    select *
    from (#{POINTS_FOR_GEMS_SQL}) points_for_gems
    where
      repository_id = :repository_id
    order by
      path, name
    SQL
  end

  def self.all_with_version_point
    # points_for_gems: gem ごとにバージョンでソートして、どれくらい上位にいるか
    # points_for_repos: そのリポジトリが依存している gem について、↑の平均値
    # 大きければ大きいほど最新の gem を使っていることになりそう
    find_by_sql(<<-SQL.strip_heredoc)
    select
      repos.*, points_for_repos.path, points_for_repos.point
    from (
      select
        repository_id, path, avg(version_point) as point
      from (#{POINTS_FOR_GEMS_SQL}) points_for_gems
      group by repository_id, path
    ) points_for_repos
      inner join #{table_name} repos on repos.id = points_for_repos.repository_id
    order by
      point desc
    SQL
  end

  # @param [String] gem_name
  # @param [String] from_version Version string in Ruby gem manner.
  # @param [String] to_version
  def self.find_by_dependent_gem(gem_name, from_version: nil, to_version: nil)
    from_version = '0.0.0' if from_version.blank?
    find_by_sql([<<-SQL.strip_heredoc, gem_name: gem_name, from_version: from_version, to_version: to_version])
    select
        repos.id
      , site
      , full_name
      , gems.version as gem_version
      , gems.path as gem_path
    from
      #{table_name} repos
      inner join #{GemCollector::RepositoryGem.table_name} gems on gems.repository_id = repos.id
    where gems.name = :gem_name
      and #{build_version_exp('version')} >= #{build_version_exp(':from_version')}
    #{to_version.blank? ? '' : "and #{build_version_exp('version')} < #{build_version_exp(':to_version')}"}
    order by
        #{build_version_exp('version')} desc
      , site
      , full_name
      , gems.path
    SQL
  end

  private_class_method def self.build_version_exp(column_or_exp)
    "(regexp_split_to_array(regexp_replace(#{column_or_exp}, '\.[^0-9.].+$', ''), '[^0-9]+') :: bigint[])"
  end
end
