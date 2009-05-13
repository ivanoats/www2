# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090513120500) do

  create_table "accounts", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "organization"
    t.string   "state"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "balance",            :precision => 10, :scale => 2, :default => 0.0
    t.date     "last_payment_on"
    t.string   "payment_period"
    t.string   "billing_id"
    t.string   "email"
    t.string   "card_number"
    t.string   "card_expiration"
    t.integer  "billing_address_id"
    t.integer  "address_id"
  end

  create_table "accounts_users", :id => false, :force => true do |t|
    t.integer "account_id"
    t.integer "user_id"
  end

  create_table "add_ons", :force => true do |t|
    t.integer  "hosting_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "addresses", :force => true do |t|
    t.text     "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articles", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "synopsis"
    t.text     "body"
    t.boolean  "published",        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.integer  "category_id",      :default => 1
    t.string   "permalink"
    t.boolean  "comments_enabled"
    t.string   "cached_tag_list"
  end

  create_table "cart_items", :force => true do |t|
    t.integer  "product_id"
    t.integer  "cart_id"
    t.text     "name"
    t.text     "description"
    t.integer  "quantity"
    t.string   "quantity_unit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "unit_price",    :precision => 10, :scale => 2, :default => 0.0
    t.text     "data"
  end

  create_table "carts", :force => true do |t|
    t.integer  "referrer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string "name"
  end

  create_table "certificate_tickets", :force => true do |t|
    t.string   "email"
    t.string   "password"
    t.string   "host"
    t.string   "country"
    t.string   "state"
    t.string   "city"
    t.string   "company_name"
    t.string   "company_division"
    t.text     "csr"
    t.text     "rsa"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "charges", :force => true do |t|
    t.integer  "account_id"
    t.integer  "chargable_id"
    t.string   "chargable_type"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "amount",         :precision => 10, :scale => 2, :default => 0.0
  end

  create_table "comments", :force => true do |t|
    t.string   "title",            :default => ""
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",          :default => 0,  :null => false
    t.string   "web_site"
    t.string   "email"
    t.string   "name"
    t.integer  "commentable_id"
    t.string   "commentable_type"
  end

  add_index "comments", ["user_id"], :name => "fk_comments_user"

  create_table "discount_codes", :force => true do |t|
    t.string   "name"
    t.integer  "percent_off"
    t.string   "status"
    t.datetime "expiration_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "domains", :force => true do |t|
    t.string   "name"
    t.boolean  "monitor_resolve"
    t.boolean  "resolved"
    t.datetime "expires_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.integer  "product_id"
  end

  create_table "four_oh_fours", :force => true do |t|
    t.string   "host"
    t.string   "path"
    t.string   "referer"
    t.integer  "count",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "four_oh_fours", ["host", "path", "referer"], :name => "index_four_oh_fours_on_host_and_path_and_referer", :unique => true
  add_index "four_oh_fours", ["path"], :name => "index_four_oh_fours_on_path"

  create_table "hostings", :force => true do |t|
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "next_charge_on"
    t.string   "state"
    t.integer  "account_id"
    t.integer  "server_id"
    t.string   "cpanel_user"
  end

  create_table "lead_sources", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",                  :null => false
    t.string  "server_url"
    t.string  "salt",       :default => "", :null => false
  end

  create_table "orders", :force => true do |t|
    t.integer  "account_id"
    t.string   "invoice_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "permalink"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "restricted"
    t.boolean  "hide_sidebar"
  end

  create_table "passwords", :force => true do |t|
    t.integer  "user_id"
    t.string   "reset_code"
    t.datetime "expiration_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_profiles", :force => true do |t|
    t.integer  "account_id"
    t.string   "customer_payment_profile_id"
    t.boolean  "active"
    t.boolean  "default"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.integer  "account_id"
    t.integer  "order_id"
    t.decimal  "amount",         :precision => 10, :scale => 2, :default => 0.0
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "transaction_id"
    t.text     "receipt"
  end

  create_table "photos", :force => true do |t|
    t.integer  "article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
  end

  add_index "photos", ["article_id"], :name => "index_photos_on_article_id"

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "recurring_month"
    t.string   "status"
    t.string   "kind"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "cost",            :precision => 10, :scale => 2, :default => 0.0
    t.text     "data"
  end

  create_table "purchases", :force => true do |t|
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "purchasable_id"
    t.integer  "purchasable_type"
  end

  create_table "redirects", :force => true do |t|
    t.string   "slug"
    t.string   "url"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "servers", :force => true do |t|
    t.string   "name"
    t.string   "ip_address"
    t.string   "vendor"
    t.string   "location"
    t.string   "primary_ns"
    t.string   "primary_ns_ip"
    t.string   "secondary_ns"
    t.string   "secondary_ns_ip"
    t.integer  "max_accounts"
    t.string   "whm_user"
    t.string   "whm_pass"
    t.text     "whm_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :default => "", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "tickets", :force => true do |t|
    t.string   "subject"
    t.text     "description"
    t.string   "domain_name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "timezone"
    t.string   "priority"
    t.string   "cpanel_username"
    t.string   "cpanel_password"
    t.string   "email"
    t.string   "email_password"
    t.string   "department"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "identity_url"
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token",            :limit => 40
    t.string   "activation_code",           :limit => 40
    t.string   "state",                                    :default => "passive", :null => false
    t.datetime "remember_token_expires_at"
    t.datetime "activated_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enabled",                                  :default => true,      :null => false
    t.text     "profile"
    t.datetime "last_login_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
