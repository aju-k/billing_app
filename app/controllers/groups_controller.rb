class GroupsController < ApplicationController

	before_action :set_group, only: [:show_all_bills, :split_bills]

	# Show all groups /groups
	def index
		@groups = current_user.groups
	end

	# Initialise new groups 
	def new
		@all_users = User.get_all_users_name(current_user)
		@group = current_user.groups.new
	end

	# Create new group and add members
	def create
		@group = current_user.groups.create(group_params)
		if params[:users].present?
			params[:users].each do |user_id|
				@group.user_groups.create(user_id: user_id)
			end
		end
		redirect_to :groups, notice: 'Group created successfully'
	end

	# Destroy group
	def destroy
		if params[:id].present?
			Group.find(params[:id]).destroy
		end
		redirect_to groups_url, notice: 'Group was successfully destroyed.'
	end

	# Show all group bills
	def show_all_bills
		@bills = @group.bills
	end

	# Split bills and show each share
	def split_bills
		@results = @group.split_total_amt(current_user)
	end

	private 

		def group_params
			params.require(:group).permit(:name, :description)
		end

		def set_group
			@group = Group.find(params[:id])
		end

end
