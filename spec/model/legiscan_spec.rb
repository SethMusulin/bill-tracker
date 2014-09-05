require 'spec_helper'
require 'legiscan_api'

describe "LegiScanApi" do
  it 'returns bill information after user inputs necessary information' do
    #stub for CO HB1030, located in fixtures/vcr_cassettes/legiscan
    VCR.use_cassette('legiscan/bills3') do
      response = LegiScanApi.new(ENV['LEGISCAN'], "CO", "SB252", "2013")
      response_body = response.retrieve_bill_info

      expect(response_body["status"]).to eq("OK")
      expect(response_body["bill"]["state"]).to eq("CO")
      expect(response_body["bill"]["session"]["session_name"]).to eq("2013 Regular Session")


    end
  end
end