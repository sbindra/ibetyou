class PicksController < ApplicationController
  before_filter :signed_in_user, only: [:create]
  
  def create
    @bet = Bet.find(params[:bet_id])
    if params[:commit] == "Share"
      
      if current_user == @bet.user
        if !@bet.betshared?
          @bet.update_attributes(:betshared => true)
        end
        
        flash[:success] = "Bet shared with friends (owner)"
      else
        @pick = @bet.userpick(current_user)

        if !@pick.nil?
          @pick.update_attributes(:betshared => true)
          flash[:success] = "Bet shared with friends"
        else
          flash[:success] = "Bet shared with friends (but no pick yet)"
        end
      end
    else
      if params[:commit] == 'PickY'
        @pick = @bet.picks.build(pick: true, user_id: current_user.id)
        @pick.save
        flash[:success] = "You picked Yes!"
      else
        @pick = @bet.picks.build(pick: false, user_id: current_user.id)
        @pick.save
        flash[:success] = "You picked No!"
      end
    end
    redirect_to edit_bet_path(@bet)
  end

end