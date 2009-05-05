class BortMigration < ActiveRecord::Migration
  def self.up
    
    create_table "articles", :force => true do |t|
      t.integer  "user_id"
      t.integer  "category_id"
      t.string   "title"
      t.string   "permalink"
      t.string   "cached_tag_list"
      t.text     "synopsis"
      t.text     "body"
      t.boolean  "published",        :default => false
      t.datetime "published_at"
      t.boolean  "comments_enabled"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "categories", :force => true do |t|
      t.string "name"
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

    create_table "open_id_authentication_associations", :force => true do |t|
      t.integer "issued"
      t.integer "lifetime"
      t.string  "handle"
      t.string  "assoc_type"
      t.binary  "server_url"
      t.binary  "secret"
    end

    create_table "open_id_authentication_nonces", :force => true do |t|
      t.integer "timestamp",  :null => false
      t.string  "server_url"
      t.string  "salt",       :null => false
    end

    create_table "pages", :force => true do |t|
      t.string   "title"
      t.string   "permalink"
      t.text     "body"
      t.integer  "user_id"
      t.boolean  "restricted"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "passwords", :force => true do |t|
      t.integer  "user_id"
      t.string   "reset_code"
      t.datetime "expiration_date"
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

    create_table "sessions", :force => true do |t|
      t.string   "session_id", :null => false
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
    
    
    # Create admin role
    admin_role = Role.create(:name => 'Administrator')
    
    # Create default admin user
    user = User.create do |u|
      u.login = 'admin'
      u.password = u.password_confirmation = 'Coo2man!!'
      u.email = APP_CONFIG[:admin_email]
    end
    
    # Activate user
    user.register!
    user.activate!
    
    # Add admin role to admin user
    user.roles << admin_role
    
    editor_role = Role.create(:name => 'Editor') 
    admin_user = User.find_by_login('admin') 
    admin_user.roles << editor_role
  end

  def self.down
    # Drop all Bort tables
    drop_table :sessions
    drop_table :users
    drop_table :passwords
    drop_table :roles
    drop_table :roles_users
    drop_table :open_id_authentication_associations
    drop_table :open_id_authentication_nonces
  end
end
