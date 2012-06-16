require 'twitter_oauth'

class TwittersController < ApplicationController

  # skip_before_filter :login_required

  before_filter :link_client

  def destroy
    begin
      current_user.twitter_token = nil
      current_user.twitter_secret = nil
      current_user.twittername = nil
      current_user.twitter_id = nil
      raise 'Could not save user' if !current_user.save
      flash[:notice] = 'Your have revoked your Twitter account authorization'
    rescue
      flash[:error] = 'Could not revoke your Twitter account authorization'
    end

    sign_in current_user
    redirect_to edit_user_path(current_user)
  end  

  # authorize oauth client and save access keys
  def new  

    begin
      if params[:oauth_token] != session['oauth_request_token_token']
        flash[:error] = 'Could not authorize your Twitter account'
        if current_user.nil?
          return redirect_to signup_path
        else
          return redirect_to edit_user_path(current_user)
        end
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
        
        if current_user.nil?
          newname = client_info['name']
          newtwittername = client_info['screen_name']
          newuserid = client_info['id_str']

          @user = User.find_by_twitter_id(newuserid)
            
          if @user.nil?
            @user = User.new(:name => newname, :twittername => newtwittername,
                      :twitter_id => newuserid, :twitter_token => access_token.token,
                      :twitter_secret => access_token.secret)
            @user.save!          
            flash[:success] = "User account created through Twitter"
          else
            @user.name = newname
            @user.twittername = newtwittername
            @user.save!
          end
            
          sign_in @user
          session['oauth_request_token_token'] = nil
          session['oauth_request_token_secret'] = nil

          redirect_to current_user          
        else
          
          twid = client_info['id_str']
          
          olduser = User.find_by_twitter_id(twid)
          if !olduser.nil?
            flash[:error] = 'Twitter account already linked to another account'
          else
            current_user.twitter_token = access_token.token
            current_user.twitter_secret = access_token.secret
            current_user.twitter_id = twid
            begin
              raise 'Could not save user' if !current_user.save
            rescue
              flash[:error] = "bad"
            end
            flash[:notice] = 'Your account has been authorized at Twitter'
            sign_in current_user
          end
          
          session['oauth_request_token_token'] = nil
          session['oauth_request_token_secret'] = nil
          return redirect_to edit_user_path(current_user)
          #rescue => e
              #flash[:error] = 'There was an error during processing the response from Twitter.'
              #flash[:error] = e.message
        end
      end    
    end
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