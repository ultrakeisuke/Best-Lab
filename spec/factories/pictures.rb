FactoryBot.define do
  factory :picture, class: Picture do
    picture { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/factories/images/rails.png'), 'image/png') }
  end
end
