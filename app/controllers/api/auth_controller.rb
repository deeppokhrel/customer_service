# frozen_string_literal: true

# // Skipping for now
class Api::AuthController < ApplicationController
  # before_action :validate_auth_token
  # skip_before_action :validate_token, only: :login

  # POST /api/auth/login
  def login
    expiry_time = 5.hours.from_now.to_i
    payload = { user: "api_client", exp: expiry_time }
    secret_token = JWT.encode(payload, SECRET_KEY, "HS256")

    render json: { token: secret_token, expiry: expiry_time }
  end

  private

  def validate_auth_token
    render json: { error: "Unauthorized" }, status: :unauthorized unless token && secret_valid?
  end

  def token
    @token ||= request.headers["Authorization"]
  end

  def secret_valid?
    [ ENV["SUPPORT_API_SECRET"], ENV["CRM_API_SECRET"], ENV["BILLING_API_SECRET"] ].any? { |secret| secret == token }
  end
end
