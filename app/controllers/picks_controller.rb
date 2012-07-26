class PicksController < ApplicationController
  before_filter :signed_in_user, only: [:create]
  
  def create
    @bet = Bet.find(params[:bet_id])
    
    if params[:commit] == "Share on Facebook"
      @bet_url = request.protocol + request.host_with_port + edit_bet_path(@bet)
      #@bet_url = 'https://gentle-snow-7462.herokuapp.com/' + edit_bet_path(@bet)
      
      begin
        current_user.facebook.feed!(
          :message => @bet.thebet,
          :link => @bet_url,
          :name => 'iBetYou',
          :description => 'What do you think?'
          )
        flash[:success] = "Bet shared on Facebook"
      rescue
          current_user.clearfacebook
          flash[:error] = "Reauthorize Facebook"
      end
    elsif params[:commit] == "Share on Twitter"
      @tweet = params[:tweet]
      
      current_user.twitter.update(@tweet, {:include_entities => true}) if current_user.twitter?
      
      if current_user == @bet.user
        if !@bet.betshared?
          @bet.update_attributes(:betshared => true)
        end
        
        flash[:success] = "Bet shared with friends (owner)"
      else
        @pick = @bet.userpick(current_user)

        if !@pick.nil?
          @pick.update_attributes(:betshared => true)
          flash[:success] = "Bet shared with friends (owner)"
        else
          flash[:success] = "Bet shared with friends (but no pick yet)"
        end
      end
    else
      if params[:commit] == 'PickY'
        @pick = @bet.picks.build(pick: true, user_id: current_user.id)
        @pick.save
        flash[:success] = "You picked Yes!"
      elsif params[:commit] == 'PickN'
        @pick = @bet.picks.build(pick: false, user_id: current_user.id)
        @pick.save
        flash[:success] = "You picked No!"
      end
    end
    redirect_to edit_bet_path(@bet)
  end

end