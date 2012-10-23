class CreateMatchPlayers < ActiveRecord::Migration
  def change
    create_table :match_players do |t|
      t.integer :match_id,  null: false
      t.integer :player_id, null: false
      t.boolean :winner,    null: false, default: false
      t.integer :team,      null: false, limit: 1

      t.timestamps
    end

    add_index :match_players, [:match_id, :player_id], unique: true
    add_index :match_players, :team
  end
end
