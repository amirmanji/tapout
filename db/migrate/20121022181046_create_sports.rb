class CreateSports < ActiveRecord::Migration
  def change
    create_table :sports do |t|
      t.string  :name,          null: false
      t.integer :base_points,   null: false, default: 0
      t.integer :matches_count, null: false, default: 0

      t.timestamps
    end
  end
end

