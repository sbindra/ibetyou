class PicksController < ApplicationController
  before_filter :signed_in_user, only: [:create]
  
  def create
    @bet = Bet.find(params[:bet_id])
    if params[:commit] == 'PickY'
      @pick = @bet.picks.build(pick: true, user_id: current_user.id)
      @pick.save
      flash[:success] = "You picked Yes!"
    else
      @pick = @bet.picks.build(pick: false, user_id: current_user.id)
      @pick.save
      flash[:success] = "You picked No!"
    end
    redirect_to edit_bet_path(@bet)
  end
  
end