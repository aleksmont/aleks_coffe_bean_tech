class UsersController < ApplicationController
  def profile
    @user = User.first



    @ip = request.remote_ip

    @result = request.location

    # Geocodificar o IP
    location = Geocoder.search(@ip).first

    if location
      @cidade = location.city
      @estado = location.state
      @pais = location.country
      puts "IP: #{@ip}"
      puts "Localização: #{@cidade}, #{@estado}, #{@pais}"
    else
      puts "Localização não encontrada."
    end

  end
end
