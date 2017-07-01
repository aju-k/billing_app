class Group < ActiveRecord::Base

	has_many :user_groups
	has_many :users, through: :user_groups
	has_many :bills

	# Get no of participants in group
	def get_no_of_users
		users.select(:id).count
	end

	# Get total expnse of group
	def get_total_expense
		bills.pluck(:amount).inject(:+) rescue 0
	end 

	# Get equal share
	def split_total_amt(current_user)
		result_array = [];
		equal_share = (get_total_expense / get_no_of_users).round(2) rescue 0
		user_share = current_user.user_expense(self.id)
		my_remaining_share = equal_share - user_share
		all_users = self.users - [current_user]
		type = my_remaining_share > 0 ? 'pay him' : 'owes you'
		result_array = find_user_split_amt(all_users, equal_share, my_remaining_share, type, result_array)
		return result_array
	end

	# Find split for each user in group
	def find_user_split_amt(all_users, equal_share ,my_remaining_share, type, result_array)
			all_users.each do |user|
				remaining_amt = equal_share - user.user_expense(self.id)
					if remaining_amt > 0
						if my_remaining_share.abs >= remaining_amt
							result_array.push([user.email, remaining_amt.abs ,type] )
						else
							result_array.push([user.email ,my_remaining_share.abs, type] )
						end
					end
			end
		result_array
	end

end
