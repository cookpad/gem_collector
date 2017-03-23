class CreateGemCollectorLatestGemVersions < ActiveRecord::Migration[5.0]
  def change
    create_table :gem_collector_latest_gem_versions do |t|
      t.string :gem_name, null: false
      t.string :version

      t.timestamps

      t.index :gem_name, unique: true
    end
  end
end
