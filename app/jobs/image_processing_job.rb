class ImageProcessingJob < ApplicationJob
  queue_as :default

  def perform(image_id)
    image = Image.find(image_id)
    image.file.reprocess!(:halfsoft, :softfocus)
    image.update_attribute(:status, 'ready')
  rescue => e
    image&.update_attribute(:status, 'failed')
    raise
  end
end
