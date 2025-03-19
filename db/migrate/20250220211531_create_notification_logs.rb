class CreateNotificationLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :notification_logs do |t|
      t.string :notification_type
      t.references :user, foreign_key: true
      t.references :reservation, foreign_key: true
      t.string :status
      t.text :error_message
      t.datetime :sent_at

      t.timestamps
    end
    
    add_index :notification_logs, :notification_type
    add_index :notification_logs, :status
  end
end