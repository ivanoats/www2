class CreateCertificateTickets < ActiveRecord::Migration
  def self.up
    create_table :certificate_tickets do |t|
      t.string :email
      t.string :password
      t.string :host
      t.string :country
      t.string :state
      t.string :city
      t.string :company_name
      t.string :company_division
      
      t.text :csr
      t.text :rsa
      
      t.timestamps
    end
  end

  def self.down
    drop_table :certificate_tickets
  end
end
