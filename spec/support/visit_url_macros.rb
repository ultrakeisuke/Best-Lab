module VisitUrlMacros
  # 本人確認用に送信したメールから本文からurlを抽出
  def extract_url(mail)
    body = mail.body.encoded
    body[/http[^"]+/]
  end

  # 抽出したurlに移動
  def visit_url_in_mail
    mail = ActionMailer::Base.deliveries.last
    url = extract_url(mail)
    visit url
  end
end
