# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :validate_token
  SECRET_KEY = Rails.application.secret_key_base

  private

  def validate_token
    begin
      decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: "HS256" })
      render json: { message: "Invalid Token" } unless decoded
    rescue JWT::DecodeError => e
      render json: { error: "Invalid token: #{e.message}" }, status: :unauthorized
    end
  end

  def token
    @token ||= request.headers["Authorization"]
  end
end
