class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :authenticated?
  PASSWORD = if Rails.env.test?
    'e5e9fa1ba31ecd1ae84f75caaa474f3a663f05f4'  # Fake password for testing ("secret")
  else
    'ce5e1f73cda2fed668eec0e4390711b7f3272a2c'  # Real password
  end
  before_action :check_login

  protected

  def authenticated?
    @authenticated
  end

  def authenticate
    if not authenticated? and not check_login
      request_http_basic_authentication
    else
      true
    end
  end

  def check_login
    authenticate_with_http_basic do |username, password|
      @authenticated = (Digest::SHA1.hexdigest(password) == PASSWORD)
    end
  end

  def not_found
    render :text => 'Not found', :status => :not_found
  end

  def forbidden
    render :text => 'Forbidden', :status => :forbidden
  end
end
