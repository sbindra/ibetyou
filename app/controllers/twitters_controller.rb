require 'twitter_oauth'

class TwittersController < ApplicationController

  # skip_before_filter :login_required

  before_filter :link_client

  def destroy
    begin
      current_user.twitter_token = nil
      current_user.twitter_secret = nil
      raise 'Could not save user' if !current_user.save
      flash[:notice] = 'Your have revoked your Twitter account authorization'
    rescue
      flash[:error] = 'Could not revoke your Twitter account authorization'
    end

    redirect_back_or edit_user_path(current_user)
  end  

  # authorize oauth client and save access keys
  def new  

    begin
      if params[:oauth_token] != session['oauth_request_token_token']
        flash[:error] = 'Could not authorize your Twitter account'
        return redirect_back_or edit_user_path(current_user)
      end
      
      oauth_token = session['oauth_request_token_token']
      oauth_secret = session['oauth_request_token_secret']
      
      # if we're here, save the tokens to user
      access_token = @client.authorize(
        oauth_token,
        oauth_secret
      )

      if @client.authorized?
        
        client_info = @client.info
        
        # current_user.update_attributes(:twitter_token => access_token.token, :twitter_secret => access_token.secret)
        
        current_user.twitter_token = access_token.token
        current_user.twitter_secret = access_token.secret
        #current_user.delete(:password) if current_user.password.blank?
        #current_user.update_attributes!(:facebookname => "updatedfb2")
        
        #@client.update('test tweet 2')
        #return render :text => "The object is #{access_token.token}, #{oauth_token}, #{@client.authorized?}"
        
        #raise 'Could not save user' if current_user.twitter_token.nil?
        raise 'Could not save user' if !current_user.save
      end
      
      session['oauth_request_token_token'] = nil
      session['oauth_request_token_secret'] = nil
      flash[:notice] = 'Your account has been authorized at Twitter'
    rescue
      flash[:error] = 'There was an error during processing the response from Twitter.'
    end

    redirect_back_or edit_user_path(current_user)
  end

  # start a request and send to twitter
  def create
    request_token = @client.request_token(:oauth_callback => 'http://127.0.0.1:3000/twitter/new')
    #request_token = @client.request_token(:oauth_callback => 'https://gentle-snow-7462.herokuapp.com/twitter/new')

    session['oauth_request_token_token'] = request_token.token
    session['oauth_request_token_secret'] = request_token.secret

    redirect_to request_token.authorize_url
  end
  
  def createpost
    if current_user.twitter?
      current_user.twitter.update('test tweet 3')
    end
  end

  private

    def link_client
      @client = TwitterOAuth::Client.new(
          :consumer_key => TWITTER_CONSUMER_KEY,
          :consumer_secret => TWITTER_CONSUMER_SECRET
      )
    end

end