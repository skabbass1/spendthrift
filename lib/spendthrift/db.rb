require 'aws-sdk-dynamodb'

module Spendthrift


  module DynamoDB


    DYNAMODB_TABLE_NAME = 'ExpenseReports'


    def self.load_report(report)
      secrets = (Spendthrift::Secrets.get_secrets)[:aws]

      Aws.config.update({
        credentials: Aws::Credentials.new(secrets[:AWS_ACCESS_KEY_ID], secrets[:AWS_SECRET_ACCESS_KEY]),
        region: secrets[:AWS_DEFAULT_REGION],
      })

      dynamodb = Aws::DynamoDB::Client.new()

      report.each do |key, value|
        params = {
            table_name: DYNAMODB_TABLE_NAME,
            item: {date: key, expenditure: value}
        }

        dynamodb.put_item(params)

      end

    end


  end

end
