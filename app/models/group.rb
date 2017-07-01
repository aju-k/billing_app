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
		hash = {}; array = [];
		equal_share = (get_total_expense / get_no_of_users).round(2) rescue 0
		 user_share = current_user.user_expense(self.id)
		 my_remaing_share = equal_share - user_share 
		 if my_remaing_share > 0
			(self.users - [current_user]).each do |user|
			 	remaing_amt = equal_share - user.user_expense(self.id)
			 	if remaing_amt < 0 
			 		# pay to him
			 		if my_remaing_share >= remaing_amt.abs
			 			array.push([user.email, remaing_amt.abs ,'pay him'] )
			 		else
			 			array.push([user.email ,my_remaing_share.abs, 'pay him'] )
			 		end
			 	end
			end
		else
			(self.users - [current_user]).each do |user|
				remaing_amt = equal_share - user.user_expense(self.id)
				if remaing_amt > 0 
					if my_remaing_share.abs >= remaing_amt
						array.push([user.email, remaing_amt.abs ,'owes you'] )
					else
						array.push([user.email ,my_remaing_share.abs, 'owes you'] )
					end
				end
			end
		end

		return array	

	end

	def calculate_amt(user)
		(get_total_expense - split_total_amt).round(2) rescue 0
		#- user.user_expense(self.id)
	end
end
