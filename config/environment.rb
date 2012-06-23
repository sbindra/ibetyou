# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Ibetyou::Application.initialize!

TWITTER_CONSUMER_KEY = '2CLb85iULCLMLx2CNIB7mg'
TWITTER_CONSUMER_SECRET = 's43cXOGnqM6H1ScYMkW9nN6bCVtPKRW5y7He8QZ88'
if Rails.env.development?
  # -- DEV SETTINGS --
  TWITTER_CALLBACK_URL = 'http://127.0.0.1:3000/twitter/new'
else
  # -- PROD SETTINGS --
  TWITTER_CALLBACK_URL = 'https://gentle-snow-7462.herokuapp.com/twitter/new'
end

if Rails.env.development?
  # -- DEV SETTINGS --
  FACEBOOK_APP_ID = '324140404327990'
  FACEBOOK_APP_SECRET = 'ffe3298b1e7520e0dd9bce61cb991f54'
  FACEBOOK_CALLBACK_URL = 'http://localhost:3000/facebook/new'
else
  # -- PROD SETTINGS --
  FACEBOOK_APP_ID = '311428115613444'
  FACEBOOK_APP_SECRET = '4409031f976bc1b04375f1b17e1523af'
  FACEBOOK_CALLBACK_URL = 'https://gentle-snow-7462.herokuapp.com/facebook/new'
end

