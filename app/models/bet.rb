class Bet < ActiveRecord::Base
  attr_accessible :betresult, :thebet
  belongs_to :user
  has_many :picks, dependent: :destroy
  
  validates :user_id, presence: true
  validates :thebet, presence: true, length: { maximum: 140 }
  
  default_scope order: 'bets.created_at DESC'
  
  def userpick(user)
    Pick.where("bet_id = ? and user_id = ?", id, user.id)[0]
  end
end
