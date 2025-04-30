class Api::V1::ApplicationController < ApplicationController
  # API全体で共通の設定やメソッドをここに定義

  # エラーハンドリング
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_validation_error

  private

  def render_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def render_validation_error(exception)
    render json: { errors: exception.record.errors }, status: :unprocessable_entity
  end
end
