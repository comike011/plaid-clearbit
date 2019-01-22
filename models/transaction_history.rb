class TransactionHistory
  attr_reader :transactions

  def initialize(transaction_history = [])
    @transactions = transaction_history[0..9].map do |transaction|
      Transaction.new(transaction, transaction_history)
    end
  end

end
