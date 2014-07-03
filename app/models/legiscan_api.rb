require 'faraday'

class LegiScanApi
  def initialize (token, state, bill, year=Time.now.year)
    @token = token
    @state = state
    @bill = bill
    @year = year
  end


  def retrieve_bill_info
    if @year ==Time.now.year
      state_and_bill_search
    else
      body = session_and_master_list_search
      find_bill_id(body)
    end
  end


  private

  def state_and_bill_search
    response = Faraday.get("http://api.legiscan.com/?key=#{@token}&op=getBill&state=#{@state}&bill=#{@bill}")
    JSON.parse(response.body)
  end

  def session_and_master_list_search
    response = Faraday.get("http://api.legiscan.com/?key=2577f3697e3597ca2363909f55f143c8&op=getSessionList&state=#{@state}")
    body = JSON.parse(response.body)
    sesh = body["sessions"].select { |session| session["name"].include?(@year) }
    response2= Faraday.get("http://api.legiscan.com/?key=#{@token}&op=getMasterList&id=#{sesh[0]["session_id"]}")
    JSON.parse(response2.body)
  end

  def find_bill_id(response)
    bill_id = 0
    response["masterlist"].each do |result|
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
