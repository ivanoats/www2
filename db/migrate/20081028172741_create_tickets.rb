class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.string :subject
      t.text :description
      t.string :domain_name
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :timezone
      t.string :priority
      t.string :cpanel_username
      t.string :cpanel_password
      t.string :email
      t.string :email_password
      t.string :department

      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end
