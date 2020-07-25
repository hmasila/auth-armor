require "auth/armor/version"
require 'rest-client'
require 'json'

module AuthArmor

	SITE_PATH = "https://api.autharmor.com/"

  class Error < StandardError; end

  class Client
  
	  attr_accessor :access_token

	  def initialize(scope: "aarmor.api.generate_invite_code aarmor.api.request_auth", client_id: , client_secret:)
	  	# check if scopes are in the list

	    payload = {
	      client_id: client_id,
	      client_secret: client_secret,
	      grant_type: "client_credentials",
	      scope: scope
	  	}

	    response = RestClient.post("https://login.autharmor.com/connect/token", payload)

	    if response.code == 200
	    	@access_token = JSON.parse(response)["access_token"]
	    else
	    	fail "Invalid response #{response.to_str} received."
	    end
	  end

	  def connect(payload: {}, params: {}, method:, endpoint:)
	  	RestClient::Request.execute(
			  method: method,
			  url: "#{API_URL}/#{endpoint}",
			  payload: payload,
			  headers: {
			  	content_type: 'application/json',
			  	Authorization: "Bearer #{@access_token}",
			  	params: params
			  }) do |response, request, result|
			  case response.code
			  when 400
			    [ :error, JSON.parse(response.to_str) ]
			  when 200
			    [ :success, JSON.parse(response.to_str) ]
			  else
			    fail "Invalid response #{response.to_str} received."
			  end
			end

		rescue RestClient::Unauthorized, RestClient::Forbidden => err
		  JSON.parse(err.response.to_str)
	  end

	  def auth_request
	  	payload = {
			  auth_profile_id: "a6f30675-3fe1-400d-af8d-ff1b902fd98d",
			  action_name: "Login",
			  short_msg: "Login requested detected from IP: 192.160.0.1",
			  timeout_in_seconds: "120",
			  accepted_auth_methods: [
			      {
			        name: "mobiledevice",      
			        rules: [
			          {
			            name: "forcebiometric",
			            value: "true"
			          }
			        ]
			      },
			      {
			        name: "securitykey",
			      }
			    ]
			  }

	  	response = connect(payload: payload, method: :post, endpoint: "auth/request")
	  end

	  def security_key_auth_request
	  end

	  def get_invite_link
	  	"it works"
	  end
	end
end
