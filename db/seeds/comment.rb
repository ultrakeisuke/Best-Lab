content = %w[本 哲学 宗教 人 学校 教育 語学 国民 医療 薬 法律 世界 社会 経済 経営
             商業 数学 物理 化学 宇宙 生物 機械 AI 情報 エネルギー 心理 臨床 生命 航空
             資格 動物 農業 漁業 林業 スポーツ 音楽 栄養 育児 建築 楽器 美容 芸術 政治
             健康 生活 介護 料理 畜産 歴史 日本史 世界史 環境 資源 材料 文化財 園芸 天気
             海洋 星 コミュニケーション 通訳 翻訳 マーケティング プログラミング 戦争 紛争 国際情勢]

# 初期ユーザー用データ
# 質問
posts = []
users = User.where(id: 1..1000)
users.each do |user|
  posts << Post.new(title: "#{user.name}の投稿です。",
                    content: "#{content.sample}の研究について教えていただきたいです。よろしくお願いします。",
                    user_id: user.id,
                    category_id: rand(16..90).to_s)
end
Post.import posts

# 質問者用の通知レコード
post_notices = []
posts.each do |post|
  post_notices << QuestionNotice.new(notice: true,
                                     user_id: post.user_id,
                                     post_id: post.id)
end
QuestionNotice.import post_notices

# 回答
answers = []
posts = Post.all.includes(:user)
posts.each do |post|
  answers << Answer.new(body: "#{post.user.name}への回答です。",
                        user_id: rand(1..1000).to_s,
                        post_id: post.id)
end
Answer.import answers

# 回答者用の通知レコード
answer_notices = []
answers = Answer.all
answers.each do |answer|
  answer_notices << QuestionNotice.new(user_id: answer.user_id,
                                       post_id: answer.post_id)
end
QuestionNotice.import answer_notices

# ゲストユーザー用データ
# 質問を2つ作成
posts_for_guest = []
guest = User.find(1001)
2.times do |n|
  posts_for_guest << Post.new(title: "guestの#{n + 1}つ目の質問です。",
                              content: "#{content.sample}の研究について教えていただきたいです。よろしくお願いします。",
                              user_id: guest.id,
                              category_id: rand(16..90).to_s)
end
Post.import posts_for_guest

# 質問者用の通知レコードを2つ作成
post_notices_for_guest = []
posts_for_guest.each do |post|
  post_notices_for_guest << QuestionNotice.new(notice: true,
                                               user_id: 1001,
                                               post_id: post.id)
end
QuestionNotice.import post_notices_for_guest

# ゲストの質問への回答
answers_for_guest = []
posts_for_guest.each do |post|
  answers_for_guest << Answer.new(body: "#{post.user.name}への回答です。",
                                  user_id: 1,
                                  post_id: post.id)
end
Answer.import answers_for_guest

# ベストアンサー
posts_for_guest[0].update(status: 'closed',
                          best_answer_id: answers_for_guest[0].id)

# リプライ
replies_for_guest = []
answers_for_guest.each do |answer|
  replies_for_guest << Reply.new(body: "#{answer.user.name}さん、回答ありがとうございます。",
                                 user_id: 1001,
                                 answer_id: answer.id)
end
Reply.import replies_for_guest

# 他人の質問に対するゲストの回答
answers_for_other_from_guest = []
5.times do |n|
  answers_for_other_from_guest << Answer.new(body: 'guestの回答です。',
                                             user_id: 1001,
                                             post_id: n + 1)
end
Answer.import answers_for_other_from_guest

# 他人の質問に回答した際のゲストの通知レコード
answer_notices_for_guest = []
5.times do |n|
  answer_notices_for_guest << QuestionNotice.new(notice: true,
                                                 user_id: 1001,
                                                 post_id: n + 1)
end
QuestionNotice.import answer_notices_for_guest
