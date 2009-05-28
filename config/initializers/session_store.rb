# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_pathwayfindr_session',
  :secret      => '1fd69cbaed6e1c3f9a8a305a0d2ad40e2058d2b4df91f7d06f4833e04c7f68ae6783250260ea05b6b75498a6612b59d3bc5f452d99520dfea1ddb551c61f228e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
