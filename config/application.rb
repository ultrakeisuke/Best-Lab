require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BestLab
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # time_zone => Tokyo
    config.time_zone = 'Tokyo'

    # DBに登録する際に created_at をPCの時刻に設定
    config.active_record.default_timezone = :local

    # デフォルトのlocaleを日本語にする
    config.i18n.default_locale = :ja

    # 複数のロケールファイルが読み込まれるようにする
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    # Rspecのテストファイルを生成
    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       controller_specs: true,
                       request_specs: false
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end

    # フォーム入力のバリデーションエラー発生時にデザインが崩れるのを防ぐ
    config.action_view.field_error_proc = Proc.new do |html_tag, instance|
      html_tag
    end

  end

end
