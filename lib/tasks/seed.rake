# 選択したseedファイルをアプリケーションに反映させるコマンドを定義
Dir.glob(File.join(Rails.root, 'db', 'seeds', '*.rb')).each do |file|
  # taskの説明
  desc "Load the seed data from db/seeds/#{File.basename(file)}."
  # 実行task名と処理
  task "db:seed:#{File.basename(file).gsub(/\..+$/, '')}" => :environment do
    load(file)
  end
end
