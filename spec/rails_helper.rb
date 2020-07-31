require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# 本番環境でDBのテーブルから全ての行を削除するのを防ぐ
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

# support/config配下(テスト用のヘルパーメソッドを使う際に記述するファイル置き場)のファイルを読み込み
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# テスト実行前に未実行のmigrationファイルを検知して実行する
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  # ロードするfixtureのパスを指定
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # ActiveRecordを使わない場合やトランザクション内でexampleを実行したくない場合は下記をコメントにする
  config.use_transactional_fixtures = false

  # ActiveRecord機能を使用しない場合はコメントアウト
  # config.use_active_record = false

  # 配置ディレクトリに応じてspecタイプ(model,controller,fixture等)を自動判別
  config.infer_spec_type_from_file_location!

  # spec実行後のbacktrace表示を簡素化
  config.filter_rails_from_backtrace!

  # テスト失敗時のノイズを減らす
  # config.filter_gems_from_backtrace("gem name")

  # deviseのhelperをcontroller内で使用
  config.include Devise::Test::ControllerHelpers, type: :controller

  # FactoryBotのメソッドを使用する際にクラス名の指定を省略
  config.include FactoryBot::Syntax::Methods

  # テスト終了時にデータを削除する
  config.before(:suite) do
    DatabaseRewinder.clean_all
  end

  config.after(:each) do
    DatabaseRewinder.clean
  end
  
end
