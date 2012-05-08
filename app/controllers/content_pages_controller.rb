class ContentPagesController < ApplicationController
  def home
    @bet = current_user.bets.build if signed_in?
    @myopenbetsfeed = current_user.myownopenbets.paginate(page: params[:page])
  end

end
