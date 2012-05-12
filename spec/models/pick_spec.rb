require 'spec_helper'

describe Pick do
  let(:user) { FactoryGirl.create(:user) }
  let(:bet) { FactoryGirl.create(:bet) }
  before { @pick = bet.picks.build(pick: true, user_id: user.id) }
  
  subject { @pick }
  
  it { should respond_to(:pick) }
  it { should respond_to(:user_id) }
  it { should respond_to(:bet_id) }
  it { should respond_to(:user) }
  it { should respond_to(:bet) }
  it { should respond_to(:correct?) }
  its(:user) { should == user }
  its(:bet) { should == bet }
  
  it { should be_valid }
  
  describe "when user_id is not present" do
    before { @pick.user_id = nil }
    it { should_not be_valid }
  end
  
  describe "when bet_id is not present" do
    before { @pick.bet_id = nil }
    it { should_not be_valid }
  end
  
end
