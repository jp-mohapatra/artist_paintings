class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # layout 'cyborg'
  layout :layout

  before_action :configure_permitted_parameters, if: :devise_controller?

	def get_states_by_country_name
	    states = {}
	    begin     
	      @country = ISO3166::Country[params[:country_val]]
	      @country.states.each {|key, value| 
	        if value['name']!=nil
	          states[key] = value['name']
	        end
	  
	            } if @country
	    rescue
	      nil
	    end
	    render json: states, status: :ok
	end



	protected
		def layout
		    # only turn it off for login pages:
		    # is_a?(Devise::SessionsController) ? false : "cyborg"
		    # or turn layout off for every devise controller:
		    devise_controller? ? false : "cyborg"
	  	end
	  	
	  	def after_sign_in_path_for(resource)
	    	root_path
	  	end

	  	def configure_permitted_parameters
   		devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :phone, :state, :country, :city, :user_name, :image ) }
	  	end
end
