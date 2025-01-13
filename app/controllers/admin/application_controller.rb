# All Administrate controllers inherit from this
# `Administrate::ApplicationController`, making it the ideal place to put
# authentication logic or other before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_admin

    private

        # Allow access only to specific email and password
        def authenticate_admin
          if user_signed_in? && current_user.admin? && current_user.email == "destiny@desiree.com"
            # Allow access to the dashboard
          else
            redirect_to root_path, alert: "Access denied. You are not authorized to view this page."
          end
        end

        # Use Devise's helper methods to check if a user is signed in
        def user_signed_in?
          current_user.present?
        end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
