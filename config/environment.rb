# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

Rails.application.configure do

	config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

end
