require "legiscan_api"

class WelcomeController < ApplicationController


def show
  if params[:state] && params[:bill]
    @state = params[:state].upcase
    @bill = params[:bill].gsub(/\d\d-/i, "").delete(' ').delete('-').upcase
    @year = params[:year]
    @search = LegiScanApi.new(ENV['LEGISCAN'], @state, @bill, @year)
    @bill_results = @search.retrieve_bill_info
  end
end
end