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
    
      before { visit edit_bet_path(bet) }
    
      it { should have_selector('h1', text: 'The Bet') }
      it { should have_selector('title', text: 'The Bet') }
      
      describe "can enter bet result" do
        it { should have_button('Yes') }
        it { should have_button('No') }
      end
      
      describe "when bet is closed" do
        let(:closed_bet) { FactoryGirl.create(:bet, user: user, betresult: true) }
        
        describe "cannot enter bet result" do
          before { visit edit_bet_path(closed_bet) }
        
          it { should_not have_button('Yes') }
          it { should_not have_button('No') }
        end
        
        describe "cannot directly update bet result" do
          before { put bet_path(closed_bet) }
          specify { response.should redirect_to(root_path) }
        end
      end
    end
    
    describe "when not bet owner" do
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      let(:wrong_bet) { FactoryGirl.create(:bet, user: wrong_user) }
    
      describe "cannot enter bet result" do
        before { visit edit_bet_path(wrong_bet) }
        it { should_not have_button('Yes') }
        it { should_not have_button('No') }
      end
      
      describe "cannot directly update bet result" do
        before { put bet_path(wrong_bet) }
        specify { response.should redirect_to(root_path) }
      end
    end
  end
  
  describe "bet picks" do
    describe "when you have not picked your bet" do
      let(:bet) { FactoryGirl.create(:bet, user: user) }
  
      before { visit edit_bet_path(bet) }
     
      it { should have_button('PickY') }
      it { should have_button('PickN') }
    end
    
    describe "when you have not picked someone else's bet" do
      let(:other_user) { FactoryGirl.create(:user, email: "other@example.com") }
      let(:bet) { FactoryGirl.create(:bet, user: other_user) }
  
      before { visit edit_bet_path(bet) }
     
      it { should have_button('PickY') }
      it { should have_button('PickN') }
    end
    
    describe "when you have already picked" do
      let(:picked_bet) { FactoryGirl.create(:bet, user: user) }
      let!(:pick) { FactoryGirl.create(:pick, user: user, bet: picked_bet) }
      
      before { visit edit_bet_path(picked_bet) }
      it { should have_content('Yes' || 'No')  }
    end
    
    describe "when you have already picked someone else's bet" do
      let(:other_user) { FactoryGirl.create(:user, email: "other@example.com") }
      let!(:other_bet) { FactoryGirl.create(:bet, user: other_user, betresult: true) }
      let!(:pick) { FactoryGirl.create(:pick, user: user, bet: other_bet) }
    
      before { visit edit_bet_path(other_bet) }
      
      describe "and the bet is closed" do
        it { should have_content(user.name) }
      end
    end
    
  end
end
