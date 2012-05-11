# == Schema Information
#
# Table name: users
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  twittername  :string(255)
#  facebookname :string(255)
#  email        :string(255)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :facebookname, :name, :twittername,
                  :password, :password_confirmation
  has_secure_password
  has_many :bets, dependent: :destroy
  has_many :picks, dependent: :destroy
  
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  
  def myownbets
    User.find_by_sql myownbets_sql(id)
  end
  
  def myownbets_sql(user_id)
    @sql = "SELECT * FROM bets WHERE user_id = #{user_id}
            UNION
            SELECT bets.* FROM bets INNER JOIN picks
              ON bets.id = picks.bet_id
            WHERE picks.user_id = #{user_id}"
  end
  
  def myownopenbets
    Bet.where("user_id = ? and betresult IS NULL", id)
  end
  
  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
    
end
