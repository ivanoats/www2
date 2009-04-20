class CreateProducts < ActiveRecord::Migration
  def self.up
    # drop_table :products if it exists with the force option
    create_table :products, :force => true do |t|
      t.string :name
      t.text :description
      t.integer :cost_in_cents
      t.integer :recurring_month
      t.string :status
      t.string :kind

      t.timestamps
    end
    
    Product.create!( {
      :name            => "Basic Web Hosting Subscription",
      :description     => "Basic Web Hosting Description",
      :cost_in_cents   => 1000,
      :recurring_month => 1,
      :status          => "active",
      :kind            => "package"
    })
    
    Product.create!( {
      :name            => "Small Business Web Hosting Subscription",
      :description     => "Small Business Web Hosting Description",
      :cost_in_cents   => 2000,
      :recurring_month => 1,
      :status          => "active",
      :kind            => "package"
    })
    
    # Product.create(  {
    #   :name            => params[:domain][:name],
    #   :description     => "Domain registration",
    #   :cost_in_cents   => 1000,
    #   :recurring_month => 0,
    #   :status          => "active",
    #   :kind            => "package"
    # })
  end

  def self.down
    drop_table :products
  end
end
