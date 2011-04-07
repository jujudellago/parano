module AuthenticatedSystem
  protected
  # Returns true or false if the user is logged in.
  # Preloads @current_user with the user model if they're logged in.
  # def logged_in?
  #     current_user != :false
  #   end
  
  def logged_in?
    #session_authenticated?
    session[:logged_in]
  end
  def admin?
     session[:logged_in]
  end



  private

  def basic_auth
   
    authenticate_or_request_with_http_basic do |username,password|
      RAILS_DEFAULT_LOGGER.error("\n basic_auth: username=#{username} password=#{password} \n")
      if username=="bigluc" && password =="parano.ugo"
        session[:logged_in]=true
      end
    end
  end


  # @@http_auth_headers = %w(X-HTTP_AUTHORIZATION HTTP_AUTHORIZATION Authorization)
  # # gets BASIC auth info
  # def get_auth_data
  #   auth_key  = @@http_auth_headers.detect { |h| request.env.has_key?(h) }
  #   auth_data = request.env[auth_key].to_s.split unless auth_key.blank?
  #   return auth_data && auth_data[0] == 'Basic' ? Base64.decode64(auth_data[1]).split(':')[0..1] : [nil, nil] 
  # end
end
