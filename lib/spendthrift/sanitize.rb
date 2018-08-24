module Spendthrift


  module DataSanitize

    def self.remove_pending_transactions(transactions)
      transactions.select {|t| !t[:pending]}
    end


    def self.remove_payments_and_refunds(transactions)
      transactions.select {|t| t[:amount] > 0}
    end


    def self.combine_categories!(transactions)
      transactions.each {|t| t[:category] = t[:category].join '-'}
    end


    def self.remove_unneeded_attributes(transactions)
      transactions.map do |t|
        {
            date: t[:date],
            amount: t[:amount],
            category: t[:category],
            vendor: t[:name]
        }
      end
    end
  end

end
