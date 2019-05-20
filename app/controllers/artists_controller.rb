class ArtistsController < ApplicationController
	before_action :get_object, :only=>[:profile, :edit_profile, :update_profile, :upload_paintings, :mark_public]#common method to get object

	def index
		@users = User.all
	end

	def profile
	end

	def edit_profile
		render :layout=> false
	end

	def update_profile
		saved = @artist.update(update_params)
		password = params[:user][:password]
		if saved
			notice = "Updated Successfully!!"
			unless @artist.valid_password?(password)
				@artist.update(password: password) 
				notice += "\n Please login with your new password!!"
				redirect_to root_path, :notice => notice
			else
				redirect_to artist_profile_path(id: @artist.try(:id)), :notice => notice
			end
		else
			redirect_to artist_profile_path(id: @artist.try(:id)), alert: "Something went wrong!!"
		end
	end

	def upload_paintings
		@artist.paintings.build(painting_params)

		if @artist.save
			redirect_to artist_profile_path(id: @artist.try(:id)), :notice => "Uploaded Successfully!!"
		else
			redirect_to artist_profile_path(id: @artist.try(:id)), :alert => @artist.errors.full_messages.to_sentence
		end
	end

	def mark_public
		painting_params = params[:paintings][:is_public]
		image_ids = painting_params.select{|key, val| key if val == "1" } if painting_params
		private_image_ids = painting_params.select{|key, val| key if val == "0" } if painting_params

		if image_ids.present? || private_image_ids.present?
			paintings = Painting.where(id: image_ids.keys) if image_ids.present?
			private_painting = Painting.where(id: private_image_ids.keys) if private_image_ids.present?
			paintings.update_all(is_public: 1) if paintings.present?
			private_painting.update_all(is_public: 0) if private_painting.present?
		end

		redirect_to artist_profile_path(id: @artist.try(:id)), :notice => "Marked Public Successfully!!"
	end

	private 

	def get_object
		@artist = User.find_by(id: params[:id])

		unless @artist.present?
			redirect_to root_path, alert: "Record not found!!"
		end
	end

	def update_params
		params.require(:user).permit(:id, :name, :email, :country, :state, :phone, :city, :image, :user_name, :about)
	end

	def painting_params
		params.require(:painting).permit(:name, :image)
	end
end
