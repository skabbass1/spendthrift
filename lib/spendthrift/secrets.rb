require "json"
require "rest-client"

module Spendthrift

  module Secrets

    def self.get_secrets
      app = get_secrets_at_path(app_secrets_path)
      aws = get_secrets_at_path(aws_secrets_path)
      {app: app[:data], aws: aws[:data]}

    end

    private

    def self.get_secrets_at_path(path)
      response = RestClient.get(
        path,
        headers={"X-Vault-Token" => ENV["VAULT_TOKEN"],
                 "content-type" => "application/json" }
      )
      JSON.parse(response.body, :symbolize_names=>true)
    end

    def self.aws_secrets_path
      "#{ENV['VAULT_LOCATION']}/aws"
    end

    def self.app_secrets_path
      "#{ENV['VAULT_LOCATION']}/spendthrift"
    end
  end
end
