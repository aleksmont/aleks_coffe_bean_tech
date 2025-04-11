module IpHelper
  TOKEN = '6b89820d302b80'

  def self.get_info(ip_address)
    begin
      url = URI("https://ipinfo.io/#{ip_address}?token=#{TOKEN}")
      res = Net::HTTP.get(url)
      resp = JSON.parse(res)
      {
        success: resp['city'].present?,
        city: resp["city"],
        state: resp["region"],
        country: resp["country"]
      }
    rescue StandardError => e
      {
        success: false,
        city: nil,
        state: nil,
        country: nil
      }
    end
  end
end