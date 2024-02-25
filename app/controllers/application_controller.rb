class ApplicationController < ActionController::Base
  include Pagy::Backend

  def base_app_uri
    "https://dummy-employees-api-8bad748cda19.herokuapp.com"
  end
end
