class BetsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  
  def create
    @bet = current_user.bets.build(params[:bet])
    if @bet.save
      flash[:success] = "Bet created!"
      redirect_to root_path
    else
      render 'content_pages/home'
    end
  end
  
  def destroy
  end
end