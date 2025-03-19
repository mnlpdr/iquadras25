class UpdateNotificationLogsReservationForeignKey < ActiveRecord::Migration[7.1]
  def up
    # Remove a foreign key existente
    remove_foreign_key :notification_logs, :reservations
    
    # Adiciona a nova foreign key com ON DELETE SET NULL
    add_foreign_key :notification_logs, :reservations, on_delete: :nullify
  end

  def down
    # Remove a foreign key com ON DELETE SET NULL
    remove_foreign_key :notification_logs, :reservations
    
    # Restaura a foreign key original
    add_foreign_key :notification_logs, :reservations
  end
end