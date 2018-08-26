module Spendthrift


  module DataSanitize

    def self.remove_pending_transactions(transactions)
      transactions.select {|t| !t[:pending]}
    end


    def self.remove_payments(transactions)
      transactions.reject {|t| (t[:category] - %w[Transfer Credit]).empty?}
    end


    def self.join_categories!(transactions)
      transactions.each {|t| t[:category] = t[:category].join '-'}
    end

    def self.add_vendor_name_to_vague_category!(transactions)
      transactions.each do |t|
        t[:category] << t[:name] if (t[:category].length.eql? 1 or t[:category].eql? ["Shops", "Digital Purchase"])
      end
    end


    def self.select_attributes(transactions, *attributes)
      transactions.map do |t|

        Hash[attributes.collect {|a| [a, t[a]]}]

      end
    end
  end

end
