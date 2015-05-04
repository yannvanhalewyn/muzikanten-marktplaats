class ImagesController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :render_bad_request
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def create
    @image = Image.new(img_params)
    if @image.save
      render json: @image, status: :created
    end
  end

  def destroy
    image = Image.find(params[:id])
    image.destroy
    render nothing: true, status: :ok
  end

  private
  def render_404
    render nothing: true, status: :not_found
  end

  def render_bad_request
    render nothing: true, status: :bad_request
  end

  def img_params
    params.require(:image).permit(:asset)
  end
end
