class AuthController < ApplicationController

  def login
  end

  def authenticate
    begin
      user = User.find_by(email: params[:email])

      if user.authenticate(params[:password])
        # revoke all other sessions
        revoke_sessions(user.id)

        ip_address = request.remote_ip
        user_session = UserSession.new(user_id: user.id, ip_address: ip_address)

        # Geocodificar o IP
        location = Geocoder.search(@ip).first

        if location
          user_session.city = location.city
          user_session.state = location.state
          user_session.country = location.country
        end

        user_session.save

        session[:current_user_id] = @user.id

        redirect_to root_path, notice: "Login was successfully."
      else
        redirect_to root_path, notice: "Login unsuccessful."
      end
    rescue StandardError => e
      redirect_to root_path, notice: "Login unsuccessful."
    end
  end

  def logout
    begin
      revoke_sessions(session[:current_user_id])
      session[:current_user_id] = nil
      redirect_to root_path, notice: "Logout successful."
    rescue StandardError => e
      redirect_to action: "new", notice: "Session not found."
    end
  end

  def revoke_sessions(user_id)
    UserSession.where(user_id: user_id).update(revoked: true)
  end
end
