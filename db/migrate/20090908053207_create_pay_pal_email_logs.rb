class CreatePayPalEmailLogs < ActiveRecord::Migration
  def self.up
    create_table :pay_pal_email_logs do |t|
      t.string :messageid
      t.integer :iid
      t.timestamps
    end
  end

  def self.down
    drop_table :pay_pal_email_logs
  end
end
