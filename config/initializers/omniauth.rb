OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], 
           :scope => 'email,public_profile,user_birthday', 
           :info_fields => "first_name,last_name,email,birthday,link", 
           :image_size => 'large',
           :secure_image_url => true
  # provider :google_oauth2, '838450273683-d8fvmop8mvkibpjutofdd3aqmpn31ok0.apps.googleusercontent.com', 'jxgEg14WD9_TCAIKoQr4vEmV', :scope => 'email, profile'
end