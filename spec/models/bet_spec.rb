require 'spec_helper'

describe Bet do
  
  let(:user) { FactoryGirl.create(:user) }
  before { @bet = user.bets.build(thebet: "Test bet") }
  
  subject { @bet }
  
  it { should respond_to(:thebet) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:betresult) }
  it { should respond_to(:picks) }
  it { should respond_to(:betshared) }
  
  it { should be_valid }
  
  describe "when user_id is not present" do
    before { @bet.user_id = nil }
    it { should_not be_valid }
  end
  
  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Bet.new(user_id: user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
  
  describe "with blank content" do
    before { @bet.thebet = " " }
    it { should_not be_valid }
  end
  
  describe "with content that is too long" do
    before { @bet.thebet = "a" * 141 }
    it { should_not be_valid }
  end
  
  describe "with betshared set to 'true'" do
    before { @bet.toggle!(:betshared) }
    
    it { should be_betshared }
  end
end
