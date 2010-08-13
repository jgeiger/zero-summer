# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper_method :admin?

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :confirm_password, :password_confirmation, :creditcard

  def admin_required
    unless admin?
      flash[:warning] = t("flash.unauthorized")
      redirect_to root_url and return false
    end
  end

  def admin?
    current_user && current_user.admin?
  end

end
