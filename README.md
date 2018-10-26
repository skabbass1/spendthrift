# Spendthrift

Spendthrift is a personal expense tracking application. It uses the [Plaid](https://plaid.com) API to get transaction information from a users credit card accounts to produce a monthly expense summary report by category

## Requirements
- **Plaid Account and API Keys**: A Plaid account can be crearted [here](https://plaid.com/pricing/).
- **AWS Account and DynamoDb access**: The app requires a DynamoDB table with the name *ExpenseReports* with a single  string *date* key to be created. The app uses Dynamodb to store historical expesne reports.
- **Mailgun Account** The app uses mailgun to email expense reports
- **Vault**:  The app uses  hashicorps vault server to store Plaid, AWS and Mailgun secrets. It assumes that you have a local vault server running on localhost:8200 

## Usage
Run ./bin/spendthrift -h to see help options

##Note
I wrote this app as a personal tool for my own needs. It is not intended to be a generic tool supporting multiple expense tracking use cases. Having said that, feel free to clone it and modify it to suite your own needs



