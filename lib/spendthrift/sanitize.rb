module Spendthrift


  module DataSanitize

    def self.remove_pending_transactions(transactions)
      transactions.select {|t| !t[:pending]}
    end


    def self.remove_payments_and_refunds(transactions)
      transactions.select {|t| t[:amount] > 0}
    end


    def self.join_categories!(transactions)
      transactions.each {|t| t[:category] = t[:category].join '-'}
    end


    def self.select_attributes(transactions, *attributes)
      transactions.map do |t|

        Hash[attributes.collect {|a| [a, t[a]]}]

      end
    end
  end

end
