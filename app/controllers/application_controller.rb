class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    helper_method :current_user, :logged_in?

    def current_user
        User.find_by(session_token: session[:session_token])
        #returns either nil or a user instance
    end

    def logged_in?
        !!current_user
        #returns just true or false
    end

    def login!(user)
        session[:session_token] = user.reset_session_token!
    end

    def logout!
        current_user.reset_session_token!
        session[:session_token] = nil
    end

    def ensure_logged_in
        redirect_to new_session_url unless logged_in?
    end

    def ensure_logged_out
        redirect_to cats_url unless !logged_in?
    end
    #Current_user Ensure_logged_in Logged_in? Login! Logout! 
end
