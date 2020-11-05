module VisitUrlMacros
  def extract_url(mail)
    body = mail.body.encoded
    body[/http[^"]+/]
  end

  def visit_url_in_mail
    mail = ActionMailer::Base.deliveries.last
    url = extract_url(mail)
    visit url
  end
end
