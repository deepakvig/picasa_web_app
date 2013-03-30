class ApplicationController < ActionController::Base
  protect_from_forgery

private

  def logged_in?
    if session[:user_id] && session[:key]
      return true
    else
      return false 
    end
  end
  helper_method :logged_in?

end
