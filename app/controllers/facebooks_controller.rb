class FacebooksController < ApplicationController

  before_filter :link_client

  def destroy
    begin
      current_user.facebook_token = nil
      current_user.facebook_id = nil
      current_user.facebookname = nil
      raise 'Could not save user' if !current_user.save
      flash[:notice] = 'Your have revoked your Facebook account authorization'
    rescue
      flash[:error] = 'Could not revoke your Facebook account authorization'
    end

    sign_in current_user
    redirect_back_or edit_user_path(current_user)
  end  

  # authorize oauth client and save access keys
  def new  

    begin
      @client.authorization_code = params[:code]
      
      access_token = @client.access_token! :client_auth_body
      fbuser = FbGraph::User.me(access_token).fetch
      
      #flash[:success] = current_user.name if !current_user.nil?
      
      if current_user.nil?
        begin
          newname = fbuser.name
          newemail = fbuser.email
          newuserid = fbuser.identifier
          fbtoken = access_token.access_token
          
          @user = User.find_by_email(newemail)
          if @user.nil?
            @user = User.find_by_facebook_id(newuserid)
            if @user.nil?
              @user = User.new(:name => newname, :email => newemail,
                      :facebook_id => newuserid, :facebook_token => fbtoken)
              @user.save!
              flash[:success] = "User account created through Facebook"
            else
              @user.name = newname
              @user.email = newemail
              @user.save!
            end
          end
          sign_in @user
          
          redirect_to current_user
        end
      
      else
        begin
          newuserid = fbuser.identifier
          olduser = User.find_by_facebook_id(newuserid)
          if !olduser.nil? && olduser != current_user
            raise 'Facebook account already linked to another account'
          else
            current_user.facebook_token = access_token.access_token
            current_user.facebook_id = newuserid
            raise 'Could not save user' if !current_user.save
            sign_in current_user
      
            flash[:notice] = 'Your account has been authorized at Facebook: ' + fbuser.name
          end
        rescue => e
          #flash[:error] = 'There was an error during processing the response from Facebook.'
          flash[:error] = e.message
        end
        
        redirect_back_or edit_user_path(current_user)
      end
    end
  end

  # start a request and send to twitter
  def create
    #request_token = @client.request_token(:oauth_callback => 'http://127.0.0.1:3000/twitter/new')
    #request_token = @client.request_token(:oauth_callback => 'https://gentle-snow-7462.herokuapp.com/twitter/new')

    #session['oauth_request_token_token'] = request_token.token
    #session['oauth_request_token_secret'] = request_token.secret
    #callback_facebook_url = 'http://localhost:3000/facebook/new'
    #newfbauth = FbGraph::Auth.new FACEBOOK_APP_ID, FACEBOOK_APP_SECRET, :redirect_uri => callback_facebook_url
    #client = newfbauth.client
    redirect_to @client.authorization_uri(
          :scope => 'user_about_me,user_status,email,publish_actions'
    )
    #redirect_to request_token.authorize_url
  end


  private

    def link_client
      callback_facebook_url = 'http://localhost:3000/facebook/new'
      newfbauth = FbGraph::Auth.new FACEBOOK_APP_ID, FACEBOOK_APP_SECRET, :redirect_uri => callback_facebook_url
      @client = newfbauth.client
    end

end