class ImagesController < ApplicationController
  layout 'modern'
  before_action :fetch_image, only: [:show, :download, :status]

  def show
  end

  def status
    render json: { status: @image.status }
  end

  def download
    unless @image.ready?
      render plain: 'Image is still being processed. Please try again shortly.', status: :accepted
      return
    end
    @image.update_attribute :downloaded_at, Time.now
    send_file @image.file.path(:softfocus), type: 'image/jpeg'
  end

  def new
  end

  def donate
  end

  def create
    @image = Image.new(file: params[:file], owner_attributes: { ip: request.remote_ip })
    @image.skip_softblur = true
    if @image.save
      ImageProcessingJob.perform_later(@image.id.to_s)
      respond_to do |format|
        format.json { render json: @image.to_json }
        format.html { redirect_to result_path(@image) }
      end
    else
      respond_to do |format|
        format.json { render json: { error: @image.error_message } }
        format.html { params[:mode] = :legacy; render :new }
      end
    end
  end

protected

  def fetch_image
    if params[:id].present? && (@image = Image.find(params[:id]))
      if @image.owner.ip != request.remote_ip
        authenticate unless authenticated?
      end
    else
      not_found
    end
  rescue
    not_found
  end
end
