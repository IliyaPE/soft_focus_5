module Paperclip
  class Softblur < Thumbnail
    def initialize(file, options = {}, attachment = nil)
      @softblur = options[:softblur]
      super
    end
  
    def transformation_command
      [] + super + [softblur, quality_flag]
    end
    
    def quality_flag
      '-quality 95'
    end
    
    def softblur
      img_size = @target_geometry.larger
      kernel = (img_size * image.blur / 1000).round
      "\\( -clone 0 -morphology Convolve 'Blur:0x#{kernel}>' \\) -compose blend -define compose:args=#{image.alpha},#{100 - image.alpha}% -brightness-contrast 0x10% -composite" if @softblur
    end
    
    def image
      @attachment.instance
    end
  end
end
