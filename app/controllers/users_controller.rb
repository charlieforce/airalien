class UsersController < ApplicationController
	def show
		@user = User.find(params[:id])
		@rooms = @user.rooms.paginate(:page => params[:page], :per_page => 6)
		@user_room_reviews = Review.where("room_id in (?) and review_type == 'room review'",@user.rooms.ids)
	end
end
