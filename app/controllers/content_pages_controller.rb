class ContentPagesController < ApplicationController
  def home
    @bet = current_user.bets.build if signed_in?
  end

end
