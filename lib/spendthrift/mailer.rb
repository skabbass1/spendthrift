require "rest-client"

module Spendthrift
  module Mailer
    def self.send_mail(content:, subject:)
      secrets = (Spendthrift::Secrets.get_secrets)[:app]
      RestClient.post "https://api:#{secrets[:MAILGUN_API_KEY]}"\
        "@api.mailgun.net/v3/#{secrets[:MAILGUN_DOMAIN_NAME]}/messages",
        :from => "Syed Abbas <mailgun@#{secrets[:MAILGUN_DOMAIN_NAME]}.mailgun.org>",
        :to => secrets[:MAILGUN_RECIPIENTS],
        :subject => subject,
        :html => content
    end
  end
end

