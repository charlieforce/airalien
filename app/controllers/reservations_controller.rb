class ReservationsController < ApplicationController
	before_action :authenticate_user!, except: [:notify]

	def preload
		room = Room.find(params[:room_id])
		today = Date.today
		reservations = room.reservations.where("start_date >= ? OR end_date >= ?", today, today)

		render json: reservations
	end

	def preview
		start_date = Date.parse(params[:start_date])
		end_date = Date.parse(params[:end_date])

		output = {
			conflict: is_conflict(start_date, end_date)
		}

		render json: output
	end

	def create
		 @room = Room.find(reservation_params[:room_id])
		if current_user != @room.user
			@reservation = current_user.reservations.create(reservation_params)
			if @reservation
				# send request to PayPal
				values = {
					business: 'chuck4u2008-facilitator@hotmail.com',
					cmd: '_xclick',
					upload: 1,
					notify_url: 'http://3458e752.ngrok.io/notify',
					amount: @reservation.total,
					item_name: @reservation.room.listing_name,
					item_number: @reservation.id,
					quantity: '1',
					return: 'http://3458e752.ngrok.io/your_trips'
				}

				redirect_to "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
			else
				redirect_to @room, alert: "Oops, something went wrong..."
			end
		else
			redirect_to @room, alert: "Oops, ypu can't book your own room ...."
		end
	end

	protect_from_forgery except: [:notify]
	def notify
		params.permit!
		status = params[:payment_status]

		reservation = Reservation.find(params[:item_number])

		if status = "Completed"
			reservation.update_attributes status: true
		else
			reservation.destroy
		end

		render nothing: true
	end

	protect_from_forgery except: [:your_trips]
	def your_trips
		@trips = current_user.reservations.where("status = ?", true)
	end

	def your_reservations
		@reservations = Reservation.where("room_id in (?)",current_user.rooms.ids).paginate(:page => params[:page], :per_page => 6)
	end

	private
		def is_conflict(start_date, end_date)
			room = Room.find(params[:room_id])

			check = room.reservations.where("? < start_date AND end_date < ?", start_date, end_date)
			check.size > 0? true : false
		end

		def reservation_params
			params.require(:reservation).permit(:start_date, :end_date, :price, :total, :room_id)
		end
end
