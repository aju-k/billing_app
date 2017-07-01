class CreateUserGroups < ActiveRecord::Migration
  def change
    create_table :user_groups do |t|
      t.belongs_to :user
      t.belongs_to :group		
      t.timestamps null: false
    end
    add_index :user_groups, [:user_id, :group_id]
  end
end
