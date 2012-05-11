class ContentPagesController < ApplicationController
  before_filter :signed_in_user,  only: :home
  def home
    @bet = current_user.bets.build if signed_in?
  end

end
