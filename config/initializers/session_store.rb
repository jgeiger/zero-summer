# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_zero-summer_session',
  :secret      => '12365459744f31550ebf05921455c7f90a4f0080287934eba43ed03ab51fcdf3b49e3d312f95610bc0ea7c9789f6e38863bb61cfb01a7bb96876f3692b1520fd'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
