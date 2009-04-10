class AllTheSaaSTables < ActiveRecord::Migration
  def self.up
    
    #tracker
    create_table :tracker_recurring_payment_profiles, :force => true do |t|
       t.column :gateway_reference,          :string, :unique => true
       t.column :gateway,                    :string
       t.column :subscription_name,          :text
       t.column :description,                :text
       t.column :currency,                   :string
       t.column :net_amount,                 :integer, :null => false
       t.column :taxes_amount,               :integer, :null => false
       t.column :outstanding_balance,        :integer
       t.column :total_payments_count,       :integer
       t.column :complete_payments_count,    :integer
       t.column :failed_payments_count,      :integer
       t.column :remaining_payments_count,   :integer
       t.column :periodicity,                :string
       t.column :trial_days,                 :integer, :default => 0
       t.column :pay_on_day_x,               :integer, :default => 0
       t.column :status,                     :string
       t.column :problem_status,             :string
       t.column :card_type,                  :string
       t.column :card_owner_memo,            :string
       t.column :created_at,                 :datetime
       t.column :updated_at,                 :datetime
       t.column :deleted_at,                 :datetime
       t.column :last_synchronized_at,       :datetime
     end
     add_index :tracker_recurring_payment_profiles, [ :gateway ], :name => 'ix_tracker_recurring_payment_profiles_gateway'
     add_index :tracker_recurring_payment_profiles, [ :gateway_reference ], :unique => true, :name => 'uix_tracker_recurring_payment_profiles_gateway_reference'
     
     create_table :tracker_transactions, :force => true do |t|
       t.column :recurring_payment_profile_id, :integer
       t.column :gateway_reference,            :string
       t.column :currency,                     :string
       t.column :amount,                       :integer
       t.column :result_code,                  :string
       t.column :result_text,                  :string
       t.column :card_type,                    :string
       t.column :card_owner_memo,              :string
       t.column :created_at,                   :datetime
       t.column :recorded_at,                  :datetime
     end
     add_index :tracker_transactions, [ :recurring_payment_profile_id ]
    
    
    #Subscription management
    create_table :subscriptions, :force => true do |t|
      t.column :account_id,                 :string, :null => false
      t.column :tariff_plan_id,             :string, :null => false
      t.column :taxes_id,                   :string, :null => false
      t.column :quantity,                   :integer, :null => false
      t.column :currency,                   :string, :null => false
      t.column :net_amount,                 :integer, :null => false
      t.column :taxes_amount,               :integer, :null => false
      t.column :periodicity,                :string, :null => false
      t.column :starts_on,                  :date,   :null => false
      t.column :ends_on,                    :date
      t.column :status,                     :string, :null => false
      t.column :created_at,                 :datetime, :null => false
      t.column :updated_at,                 :datetime
      t.column :deleted_at,                 :datetime
    end
    add_index :subscriptions, [ :account_id ], :name => 'ix_subscription_account'
    create_table :subscription_profiles, :force => true do |t|
      t.column :subscription_id, :integer,      :null => false
      t.column :recurring_payment_profile_id, :integer, :null => false
      t.column :created_at,                 :datetime, :null => false
    end
    add_index :subscription_profiles, [ :subscription_id ], :name =>'ix_subscription_profiles_subscription'
  end

  def self.down
    drop_table :tracker_recurring_payment_profiles
    drop_table :tracker_transactions
    
    drop_table :subscription_profiles
    drop_table :subscriptions
  end
end

