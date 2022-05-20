class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def render_404
    render json: {msg: 'resource not found'}, status: 404 and return
  end
end
