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
    response = Faraday.get("https://api.legiscan.com/?bill=#{@bill}&key=#{@token}&op=getBill&state=#{@state}")
    JSON.parse(response.body)
  end

  def session_and_master_list_search
    response = Faraday.get("https://api.legiscan.com/?key=#{@token}&op=getSessionList&state=#{@state}")
    body = JSON.parse(response.body)
    sesh = body["sessions"].select { |session| session["name"].include?(@year) }
    response2= Faraday.get("https://api.legiscan.com/?id=#{sesh[0]["session_id"]}&key=#{@token}&op=getMasterList")
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
    response3 = Faraday.get("https://api.legiscan.com/?id=#{bill_id}&key=#{@token}&op=getBill")
    JSON.parse(response3.body)
  end

end
