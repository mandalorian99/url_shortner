class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token
  before_action :prepare, only: [:create]
  before_action :set_resource, only: [:show]

  rescue_from ActiveRecord::RecordInvalid, with: :render_error

  def index
    render json: {urls: ShortUrl.top_urls}, status: 200
  end

  def create
    if @resource.save!
      render json: {short_code: @resource.shortcode}, status: 201
    end
  end

  def show
    redirect_to @resource.full_url, status: 302
  end

  private

  def short_url_params
    params.permit(:id, :full_url)
  end
  
  def prepare
    @resource = ShortUrl.new short_url_params
  end

  def set_resource
    @resource = ShortUrl.find_by!(shortcode: short_url_params[:id])
    @resource.increment :click_count
    @resource.save
  end

  def render_error
    render json: {errors: "Full url is not a valid url"}, status: 401
  end

end
