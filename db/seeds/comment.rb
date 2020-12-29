post = Post.create(title: "test", content: "test", user_id: 1, category_id: 50)

answers = []
3.times do |n|
  answers << Answer.new(body: "answer-#{n+1}",
                        user_id: n+1,
                        post_id: post.id)
end
Answer.import answers

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
