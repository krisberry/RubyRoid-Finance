class TokensController < ApplicationController

  def get_token
    Twilio::Util::AccessToken.new(ENV['ACCOUNT_SID'], ENV['API_KEY_SID'], ENV['API_KEY_SECRET'], 3600, {name: current_user.full_name, image: current_user.get_image_url}.to_json)
  end

  def get_grant 
    grant = Twilio::Util::AccessToken::IpMessagingGrant.new 
    grant.endpoint_id = "Chatty:#{current_user.full_name.gsub(" ", "_")}:browser"
    grant.service_sid = ENV['IPM_SERVICE_SID']
    grant
  end

  def create
    token = get_token
    grant = get_grant
    token.add_grant(grant)
    render json: {username: current_user.full_name, token: token.to_jwt, userimage: current_user.get_image_url}
  end
end