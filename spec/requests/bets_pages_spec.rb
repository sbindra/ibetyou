require 'spec_helper'

describe "Bets Pages" do
  
  subject { page }
  
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }
  
  describe "bet creation" do
    before { visit root_path }
    
    describe "with invalid information" do
      
      it "should not create a bet" do
        expect { click_button "Create Bet" }.should_not change(Bet, :count)
      end
      
      describe "error messages" do
        before { click_button "Create Bet" }
        it { should have_content('error') }
      end
    end
    
    describe "with valid information" do
      
      before { fill_in 'bet_thebet', with: "Lorem ipsum" }
      it "should create a bet" do
        expect { click_button "Create Bet" }.should change(Bet, :count).by(1)
      end
    end
  end
end
