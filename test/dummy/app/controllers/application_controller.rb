class ApplicationController < ActionController::Base
  protect_from_forgery
  default_rescue

  def current_user
  end  
end
