require 'faraday'

class LegiScanApi
  def initialize (token)
    @token = token
  end

  def call(state, bill)
    response = Faraday.get("http://api.legiscan.com/?key=#{@token}&op=getBill&state=#{state}&bill=#{bill}")
    JSON.parse(response.body)
  end
end
