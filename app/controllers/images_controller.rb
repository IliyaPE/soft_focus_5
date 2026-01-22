class ImagesController < ApplicationController
  before_action :fetch_image, :only => [:show, :download]

  def show
  end

  def download
    # result file download proxy
    @image.update_attribute :downloaded_at, Time.now
    send_file @image.file.path(:softfocus), :type=>"image/jpeg"
  end

  def new
  end

  def create
    @image = Image.new :file => params[:file], :owner_attributes => {:ip => request.remote_ip}
    if @image.save
      respond_to do |format|
        format.json { render :json => @image.to_json }    # Ajax upload
        format.html { redirect_to result_path(@image) }   # Legacy upload
      end
    else
      respond_to do |format|
        format.json { render :json => {:error => @image.error_message} }    # Ajax upload
        format.html { params[:mode] = :legacy; render :new }   # Legacy upload
      end
    end
  end

protected
  def fetch_image
    if params[:id].present? and @image = Image.find(params[:id])
      if @image.owner.ip != request.remote_ip
        authenticate if not authenticated?
      end
    else
      not_found
    end
  rescue
    not_found
  end
end
