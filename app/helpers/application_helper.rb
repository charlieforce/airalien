module ApplicationHelper
	def avatar_url(user)
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		if user.profile_picture_file_name
			user.profile_picture.url(:medium)
		elsif user.image
			user.image
		else
			"https://www.gravatar.com/avatar/#{gravatar_id}.jpg?s=150"
		end
	end
	def check_for_guest_review(user_id,room_id)
		result = Review.where(:user_id => user_id, :room_id => room_id , :review_type => 'guest review')
		return result
	end
end
