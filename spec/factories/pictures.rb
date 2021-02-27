FactoryBot.define do
  factory :picture, class: Picture do
    picture { Rack::Test::UploadedFile.new(Rails.root.join('spec/factories/images/rails.png'), 'image/png') }
  end
end
