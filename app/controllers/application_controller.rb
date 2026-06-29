require 'bcrypt'

class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :authenticated?
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
    authenticate_with_http_basic do |_username, password|
      @authenticated = if Rails.env.test?
        password == 'secret'
      else
        digest = ENV['ADMIN_PASSWORD_DIGEST'].to_s
        !digest.empty? && BCrypt::Password.new(digest) == password
      end
    end
  rescue BCrypt::Errors::InvalidHash
    @authenticated = false
  end

  def not_found
    render plain: 'Not found', status: :not_found
  end

  def forbidden
    render plain: 'Forbidden', status: :forbidden
  end
end
