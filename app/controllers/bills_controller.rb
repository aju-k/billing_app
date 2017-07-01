class BillsController < ApplicationController

	before_action :set_group, only:[:new, :create, :show]

	# Add new bill
	def new
		@bill = @group.bills.new
		@users = @group.users.pluck(:email, :id)
	end

	# Add new bill
	def create
		@group.bills.create(bill_params)
		redirect_to :groups, notice: 'Bill created successfully'
	end

	# Show all bills
	def show_all_bills_of_group
		@bills = @group.bills
	end

	# Destroy bill
	def destroy
		if params[:id].present?
			Bill.find(params[:id]).destroy
		end
		redirect_to bills_url, notice: 'Bill was successfully destroyed.'
	end
	

	private
		def set_group
    		@group = Group.find(params[:group_id])
		end

		def bill_params
			params.require(:bill).permit(:name, :location, :amount, :user_id, :payment_date)
		end

end
