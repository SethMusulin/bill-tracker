require 'faraday'

class LegiScanApi
  def initialize (token, state, bill,year=Time.now.year)
    @token = token
    @state = state
    @bill = bill
    @year = year
  end



  def retrieve_bill_info
    if @year ==Time.now.year
      response = Faraday.get("http://api.legiscan.com/?key=#{@token}&op=getBill&state=#{@state}&bill=#{@bill}")
      JSON.parse(response.body)
    else
      response = Faraday.get("http://api.legiscan.com/?key=2577f3697e3597ca2363909f55f143c8&op=getSessionList&state=#{@state}")
      body = JSON.parse(response.body)
      sesh = body["sessions"].select {|session| session["name"].include?(@year)}
      response2= Faraday.get("http://api.legiscan.com/?key=#{@token}&op=getMasterList&id=#{sesh[0]["session_id"]}")
       body2 = JSON.parse(response2.body)
      bill_id= 0
      body2["masterlist"].each do |result|
        result.each do |bill|
          if bill["number"] == @bill
            bill_id = bill["bill_id"]
          end
        end
      end
      response3 = Faraday.get("http://api.legiscan.com/?key=#{@token}&op=getBill&id=#{bill_id}")
       JSON.parse(response3.body)
    end

  end

  # def session_id
  #   case
  #     when @year == 2014
  #       "1077"
  #     when @year == 2013
  #       "994"
  #     when @year == 2012
  #       "925"
  #     when @year == 2011
  #       "111"
  #     when @year == 2010
  #       "68"
  #   end
  # end
end
