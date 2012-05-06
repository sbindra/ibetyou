class Bet < ActiveRecord::Base
  attr_accessible :betresult, :thebet
  belongs_to :user
  
  validates :user_id, presence: true
  validates :thebet, presence: true, length: { maximum: 140 }
  
  default_scope order: 'bets.created_at DESC'
end
