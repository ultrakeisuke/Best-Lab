module CarrierWave
  module RMagick

    def quality(percentage)
      manipulate! do |img|
        img.write(current_path){ self.quality = percentage } unless img.quality == percentage
        img = yield(img) if block_given?
        img
      end
    end

    # reduce image noise and reduce detail levels
    #
    #   process :blur => [0, 8]
    #
    def blur(radius, sigma)
      manipulate! do |img|
        img = img.blur_image(radius, sigma)
        img = yield(img) if block_given?
        img
      end
    end

    def unsharp_mask(radius, sigma, amount, threshold)
      manipulate! do |img|
        img = img.unsharp_mask(radius, sigma, amount, threshold)
        img = yield(img) if block_given?
        img
      end
    end

  end
end