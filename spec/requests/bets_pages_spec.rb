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
  
  describe "bet view" do
    
    describe "as bet owner" do
      let(:bet) { FactoryGirl.create(:bet, user: user) }
    
      before { visit bet_path(bet) }
    
      it { should have_selector('h1', text: 'The Bet') }
      it { should have_selector('title', text: 'The Bet') }
      
      describe "can enter bet result" do
        it { should have_button('Yes') }
        it { should have_button('No') }
      end
    end
    
    describe "when not bet owner" do
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      let(:bet) { FactoryGirl.create(:bet, user: wrong_user) }
    
      before { visit bet_path(bet) }
      
      describe "can not enter bet result" do
        it { should_not have_button('Yes') }
        it { should_not have_button('No') }
      end
      
      describe "can not directly update bet result" do
        
      end
    end
    
    describe "when not signed in" do
      
    end
  end
end
