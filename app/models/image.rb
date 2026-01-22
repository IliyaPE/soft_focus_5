class Image
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  SIZE_LIMIT = 10.megabytes

  field :blur, :type => Integer, :default => 6            # Blur kernel width
  field :alpha, :type => Float, :default => 40            # Blurred layer alpha
  field :downloaded_at, :type => DateTime
  embeds_one :owner

  index created_at: 1
  index downloaded_at: 1

  accepts_nested_attributes_for :owner

  has_mongoid_attached_file :file,
    :url => "/system/:class/:id_partition/:basename-:style.:extension",
    :styles => {
      :mini => {:geometry => '220x220#', :format => :jpg},
      :half => {:geometry => '400x400>', :format => :jpg},
      :halfsoft => {:geometry => '400x400>', :format => :jpg, :softblur => true},
      :softfocus => {:geometry => '2048x2048>', :format => :jpg, :softblur => true},
    },
    :processors => [:softblur]

  validates_attachment_presence :file
  validates_attachment_content_type :file, :content_type => ['image/jpg', 'image/png', 'image/gif', 'image/jpeg']
  validates_attachment_size :file, :in => 0..SIZE_LIMIT

  def as_json opts = {}
    {
      id: id.to_s,
      blur: blur,
      alpha: alpha
    }
  end

  def error_message
    if errors[:file_content_type].present?
      "This is not an image ! currently supported formats are jpg, jpeg, png & gif."
    elsif errors[:file].present?
      "I think you should select a file first, it's not THAT magical."
    elsif errors[:file_file_size].present?
      "This file is too big ! the current size limit is #{SIZE_LIMIT/1024/1024} MB."
    else
      nil
    end
  end
end
