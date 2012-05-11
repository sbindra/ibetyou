class Pick < ActiveRecord::Base
  attr_accessible :user_id, :pick
  belongs_to :user
  belongs_to :bet
  
  validates :user_id, presence: true
  validates :bet_id, presence: true
  
  def correct?(bet)
    pick == bet.betresult
  end
  
end
