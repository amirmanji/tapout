class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :sport_id,      null: false
      t.integer :player_count,  null: false, default: 0

      t.timestamps
    end
  end
end

