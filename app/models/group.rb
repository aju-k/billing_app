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
		equal_share = (get_total_expense / get_no_of_users).round(2) rescue 0
		#all_users = self.users - [current_user]
		all_users = self.users
		result_array = find_user_split_amt(all_users, equal_share, current_user)
		return result_array
	end

	# Find split for each user in group
	def find_user_split_amt(all_users, equal_share , current_user)
		result_array = [];
		tmp_array = all_users.map{|user| [user.email, equal_share - user.user_expense(self.id)]}
		p_array = tmp_array.select{|email, v| v > 0 }
		n_array = tmp_array - p_array
		#n_array = tmp_array.select{|email, v| v < 0 }

		p_array.each_with_index do |p_record, p_index|
			n_array.each_with_index do |n_record, n_index|
				if n_record[1].abs > p_record[1]
					puts "#{p_record[0]} will pay to #{n_record[0]} value = #{p_record[1]}"
					result_array = create_result_set(p_record, n_record, current_user, result_array, p_record[1])
					n_value = n_record[1].abs - p_record[1]
					n_array[n_index] = [n_record[0], n_value]
					n_record = [n_record[0], n_value]
					p_array[p_index] = [p_record[0], 0]
					p_record = [p_record[0], 0]
				else
					puts "#{p_record[0]} will pay to #{n_record[0]} value = #{n_record[1].abs}"
					result_array = create_result_set(p_record, n_record, current_user, result_array, n_record[1].abs)
					value = p_record[1] - n_record[1].abs
					p_array[p_index] = [p_record[0], value]
					p_record = [p_record[0], value]
					n_record = [n_record[0], 0]
					n_array[n_index] = [n_record[0], 0]
				end
			end
		end
		return result_array
	end

	def create_result_set(p_record, n_record, current_user, result_array, replace_value)
		if p_record[0] == current_user.email && replace_value > 0
			result_array.push([n_record[0], replace_value, 'pay him'])
		elsif n_record[0] == current_user.email && replace_value > 0
			result_array.push([p_record[0], replace_value, 'owes you'])
		end
		result_array
	end


end
