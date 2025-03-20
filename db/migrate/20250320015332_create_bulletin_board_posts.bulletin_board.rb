# This migration comes from bulletin_board (originally 20250320015116)
class CreateBulletinBoardPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :bulletin_board_posts do |t|
      t.string :username, null: false
      t.string :contact, null: false
      t.text :message, null: false
      t.string :sport, null: false
      t.date :date, null: false
      t.integer :players_needed, default: 1
      t.string :location
      t.time :preferred_time

      t.timestamps
    end
    
    add_index :bulletin_board_posts, :sport
    add_index :bulletin_board_posts, :date
  end
end