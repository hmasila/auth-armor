require "auth/armor/version"
require 'rest-client'
require 'json'

module AuthArmor

	API_URL = "https://api.autharmor.com/v1"
	ACCEPTED_SCOPES = [
		"aarmor.api.generate_invite_code aarmor.api.request_auth",
		"aarmor.api.generate_invite_code",
		"aarmor.api.request_auth"
	]

  class Error < StandardError; end

  class Client
	  attr_accessor :access_token

	  def initialize(scope: "aarmor.api.generate_invite_code aarmor.api.request_auth", client_id: , client_secret:)
	  	fail "Accepted scopes are aarmor.api.generate_invite_code or aarmor.api.request_auth. Default is both."

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

	  def connect(payload: {}, method:, endpoint:)
	  	RestClient.post("#{API_URL}/#{endpoint}",
			  payload.to_json,
			  {
			  	content_type: 'application/json',
			  	Authorization: "Bearer #{@access_token}"
			  }) do |response, request, result|
	  		# require 'pry'; binding.pry
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

	  def auth_request(timeout_in_seconds: nil, forcebiometric: false, accepted_auth_methods: nil, auth_profile_id:, action_name:, short_msg:)
	  	payload = {
			  auth_profile_id: "a6f30675-3fe1-400d-af8d-ff1b902fd98d",
			  action_name: "Login",
			  short_msg: "Login requested detected from IP: 192.160.0.1",
			  timeout_in_seconds: timeout_in_seconds,
			  accepted_auth_methods: auth_methods(accepted_auth_methods, forcebiometric)
			}

	  	connect(payload: payload, method: :post, endpoint: "auth/request")
	  end

	  def invite_request(reference_id: nil, nickname:)
	  	payload = {
	  		nickname: nickname,
	  		reference_id: reference_id
	  	}

	  	connect(payload: payload, method: :post, endpoint: "invite/request")
	  end

	  private

	  def auth_methods(accepted_auth_methods, forcebiometric)
	  	mobile_device = {
        name: "mobiledevice",      
        rules: [
          {
            name: "forcebiometric",
            value: forcebiometric
          }
        ]
      }
			security_key = { name: "securitykey" }

			if accepted_auth_methods == "securitykey"
				[securitykey]
			elsif accepted_auth_methods == "mobiledevice"
				[mobiledevice]
			else
				[mobiledevice, securitykey]
	  	end
	  end
	end
end
