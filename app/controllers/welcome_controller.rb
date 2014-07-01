require "legiscan_api"

class WelcomeController < ApplicationController

  #
  #def index
  #
  #end


def create
  @search = Search.new
  @search.bill=params[:bill]
  @search.state=params[:state]
  @search.user_id=current_user.id
end

def show
  if params[:state] && params[:bill]
    @state = params[:state]
    @bill = params[:bill].gsub(/\d\d-/i, "").delete(' ').delete('-')
    @year = params[:year]
    @search = LegiScanApi.new(ENV['LEGISCAN'], @state, @bill, @year)
    @bill_results = @search.retrieve_bill_info
  end
end
end