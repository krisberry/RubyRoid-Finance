OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1179405328750092', '03a2137a9c36c737077240da130c2ac2', 
           :scope => 'email, public_profile, user_birthday', 
           :info_fields => "first_name, last_name, email, birthday", 
           :image_size => 'large', 
           :secure_image_url => true
  # provider :google_oauth2, '838450273683-d8fvmop8mvkibpjutofdd3aqmpn31ok0.apps.googleusercontent.com', 'jxgEg14WD9_TCAIKoQr4vEmV', :scope => 'email, profile'
end