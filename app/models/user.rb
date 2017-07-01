class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :bills


  def self.get_all_users_name(user)
  	all - [user]
  end

  def user_expense(group_id)
    amt = Bill.where(group_id: group_id, user_id: self.id).pluck(:amount)
    amt.present? ? amt.inject(:+) : 0
  end


end
