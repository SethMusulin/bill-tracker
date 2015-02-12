require 'faraday'

class LegiScanApi
  def initialize (token, state, bill, year=Time.now.year)
    @token = token
    @state = state
    @bill = bill
    @year = year
  end



  def retrieve_bill_info
    states = ["AK", "AL", "AR", "AS", "AZ", "CA", "CO", "CT", "DC", "DE", "FL", "GA", "GU", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD", "ME", "MI", "MN", "MO", "MS", "MT", "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "OH", "OK", "OR", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UT", "VA", "VI", "VT", "WA", "WI", "WV", "WY"]
    results = {}
    if !states.include?(@state)
      results['status'] = 'ERROR'
      return results
    else
      if @year ==Time.now.year
       results = state_and_bill_search
      else
        body = session_and_master_list_search
        results = find_bill_id(body)
      end
    end
    results
  end


  private

  def state_and_bill_search
    response = Faraday.get("https://api.legiscan.com/?bill=#{@bill}&key=#{@token}&op=getBill&state=#{@state}")
    results = JSON.parse(response.body)
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
