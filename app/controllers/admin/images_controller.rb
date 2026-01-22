class Admin::ImagesController < ApplicationController
  before_action :fetch_image, :only => [:show, :update, :destroy]
  before_action :authenticate
  layout 'admin'

  def show
  end

  def index
    @images = Image.order_by(:created_at => :desc).page(params[:page]).per(16).all
  end

  def destroy
    @image.destroy
    redirect_to admin_images_path
  end

protected
  def fetch_image
    if params[:id].present?
      not_found if not @image = Image.find(params[:id])
    end
  rescue
    not_found
  end
end
