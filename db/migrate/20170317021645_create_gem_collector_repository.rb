class CreateGemCollectorRepository < ActiveRecord::Migration[5.0]
  def change
    create_table :gem_collector_repositories do |t|
      t.string :site, null: false
      t.integer :repository_id, null: false
      t.string :full_name, null: false
      t.string :ssh_url, null: false
      t.timestamps

      t.index [:site, :repository_id], unique: true, name: 'idx_repositories'
    end
  end
end
