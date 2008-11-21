class CorrectAdminRole < ActiveRecord::Migration
  def self.up
    role = Role.find_by_name("admin")
    role.update_attribute(:name, "Administrator") if role
  end

  def self.down
  end
end
