class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.string :name
      t.belongs_to :user
      t.belongs_to :group	
      t.float :amount
      t.string :location
      t.datetime :payment_date
      t.timestamps null: false
    end
  end
end
