#!/usr/bin/env ruby

require "auth/armor/version"
require 'rest-client'
require 'json'

module AuthArmor

	API_URL = "https://api.autharmor.com/v1"
	INVITE_URL = "https://invite.autharmor.com"
	ACCEPTED_SCOPES = [
		"aarmor.api.generate_invite_code aarmor.api.request_auth",
		"aarmor.api.generate_invite_code",
		"aarmor.api.request_auth"
	]

  class Error < StandardError; end

  class Client
	  attr_accessor :access_token, :invite_code

	  def initialize(scope: "aarmor.api.generate_invite_code aarmor.api.request_auth", client_id: , client_secret:)
	  	fail "Scope not allowed." unless ACCEPTED_SCOPES.include? scope

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
			  case response.code
			  when 400
			    { code: :error, response: JSON.parse(response.to_str) }
			  when 200
			   	{ "code" => :success, "response" => JSON.parse(response.to_str) }
			  else
			    fail "Invalid response #{response.to_str} received."
			  end
			end

		rescue RestClient::Unauthorized, RestClient::Forbidden => err
		  JSON.parse(err.response.to_str)
	  end

	  def auth_request(longitude: nil, latitude: nil, nonce: nil, timeout_in_seconds: nil, forcebiometric: false, accepted_auth_methods: nil, nickname:, action_name:, short_msg:)
	  	payload = {
			  nickname: nickname,
			  action_name: action_name,
			  short_msg: short_msg,
			  timeout_in_seconds: timeout_in_seconds,
			  nonce: nonce,
			  accepted_auth_methods: auth_methods(accepted_auth_methods, forcebiometric),
			  origin_location_data: {
				  longitude: longitude,
				  latitude: latitude
			  }
			}

	  	connect(payload: payload, method: :post, endpoint: "auth/request")
	  end

	  def invite_request(reference_id: nil, reset_and_reinvite: false, nickname:)
	  	payload = {
	  		nickname: nickname,
				reference_id: reference_id,
				reset_and_reinvite: reset_and_reinvite
	  	}

	  	response = connect(payload: payload, method: :post, endpoint: "invite/request")

	  	if response["code"] == :success
	  		@invite_code = response["response"]
	  	else
	  		@invite_code = nil
	  	end

	  	response
	  end

	  def generate_qr_code
	  	fail "QR code could not be generated. Use the invite_request method to get an invite code" if @invite_code.nil?
	  	
	  	aa_sig = @invite_code["aa_sig"]
	  	invite_code = @invite_code["invite_code"]

			{
			  "type": "profile_invite",
			  "version": 1,
			  "format_id": 1,
			  "payload": {
			    "aa_sig": aa_sig,
			    "invite_code": invite_code
			  }
			}

	  end

	  def get_invite_link
	  	fail "Invite link could not be generated. Use the invite_request method to get an invite code" if @invite_code.nil?

	  	aa_sig = @invite_code["aa_sig"]
	  	invite_code = @invite_code["invite_code"]
	  	
	  	"#{INVITE_URL}/?i=#{invite_code}&aa_sig=#{aa_sig}"
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
				[security_key]
			elsif accepted_auth_methods == "mobiledevice"
				[mobile_device]
			else
				[mobile_device, security_key]
	  	end
	  end
	end
end
