post = Post.create(title: "test", content: "test", user_id: 1, category_id: 50)
post_entry = QuestionEntry.create(user_id: 1, post_id: post.id)

answers = []
3.times do |n|
  answers << Answer.new(body: "answer-#{n+1}",
                        user_id: n+1,
                        post_id: post.id)
end
Answer.import answers

answer_entries = []
2.times do |n|
  answer_entries << QuestionEntry.new(user_id: n+2, post_id: post.id)
end
QuestionEntry.import answer_entries

replies = []
3.times do |n|
  answers.each do |answer|
    replies << Reply.new(body: "reply-#{n+1}",
                         user_id: n+1,
                         post_id: post.id,
                         answer_id: answer.id)
  end
end
Reply.import replies
