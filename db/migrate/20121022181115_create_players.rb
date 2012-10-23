class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string  :name,        null: false
      t.string  :office
      t.string  :match_count, null: false, default: 0

      t.timestamps
    end
  end
end

