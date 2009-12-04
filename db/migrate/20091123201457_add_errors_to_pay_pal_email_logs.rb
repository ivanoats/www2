class AddErrorsToPayPalEmailLogs < ActiveRecord::Migration
  def self.up
    add_column :pay_pal_email_logs, :comments, :text
  end

  def self.down
    remove_column :pay_pal_email_logs, :comments
  end
end
