class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      ip_address = request.remote_ip
      user_session = UserSession.new(user_id: @user.id, ip_address: ip_address)

      # Geocodificar o IP
      location = Geocoder.search(@ip).first

      if location
        user_session.city = location.city
        user_session.state = location.state
        user_session.country = location.country
      end

      user_session.save

      session[:current_user_id] = @user.id

      redirect_to root_path, notice: "User was successfully created."
    else
      # Add `status: :unprocessable_entity` here
      render :new, status: :unprocessable_entity
    end
  end

  def profile
    begin
      @current_user_id = session[:current_user_id]
      @user = User.find(@current_user_id)
      @user_session = UserSession.where(user_id: @user.id, revoked: false).first
    rescue StandardError => e
      redirect_to '/auth/login', notice: "Session not found."
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
