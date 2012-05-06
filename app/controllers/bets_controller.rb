class BetsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy, :edit, :update]
  before_filter :open_bet, only: [:update]
  before_filter :bet_owner, only: [:update]
  
  def create
    @bet = current_user.bets.build(params[:bet])
    if @bet.save
      flash[:success] = "Bet created!"
      redirect_to @bet
    else
      render 'content_pages/home'
    end
  end
  
  def destroy
  end
  
  def show
    @bet = Bet.find(params[:id])
  end
  
  def edit
    @bet = Bet.find(params[:id])
  end
  
  def update
    @bet = Bet.find(params[:id])
    if params[:commit] == 'Yes'
      @bet.update_attributes(:betresult => true)
      flash[:success] = "Results = Yes!"
    else
      @bet.update_attributes(:betresult => false)
      flash[:success] = "Results = No!"
    end
    redirect_to edit_bet_path(@bet)
  end
  
  private
  
    def open_bet
      @bet = Bet.find(params[:id])
      redirect_to(root_path) unless @bet.betresult.nil?
    end
    
    def bet_owner
      @bet = Bet.find(params[:id])
      redirect_to(root_path) unless @bet.user == current_user
    end
end