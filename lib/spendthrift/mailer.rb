require "rest-client"

def send_mail(content:, subject:)
  RestClient.post "https://api:#{ENV.fetch('MAILGUN_API_KEY')}"\
    "@api.mailgun.net/v3/#{ENV.fetch('MAILGUN_DOMAIN_NAME')}/messages",
    :from => "Syed Abbas <mailgun@#{ENV.fetch('MAILGUN_DOMAIN_NAME')}.mailgun.org>",
    :to => ENV.fetch("MAILGUN_RECIPIENTS"),
  :subject => subject,
  :html => content
end
