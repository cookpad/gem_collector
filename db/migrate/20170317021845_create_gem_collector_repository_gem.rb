class CreateGemCollectorRepositoryGem < ActiveRecord::Migration[5.0]
  def change
    create_table :gem_collector_repository_gems do |t|
      t.integer :repository_id, null: false
      t.string :name, null: false
      t.string :version, null: false
      t.string :path, null: false
      t.timestamps

      t.index [:repository_id, :path, :name], unique: true, name: 'idx_repository_gems'
    end
  end
end
