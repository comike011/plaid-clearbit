require 'forwardable'

class Transaction
  extend Forwardable
  attr_accessor :amount, :frequency, :name, :date, :category, :company, :previous_attributes

  def initialize(transaction_data, transaction_history = [])
    @amount = transaction_data.fetch(:amount, '')
    @name = transaction_data.fetch(:name, '')
    @date = transaction_data.fetch(:date, '')
    @category = transaction_data.fetch(:category, []).join(", ")
    @frequency = determine_frequency(transaction_history)
    @company = Company.new(transaction_data.fetch(:name, ''))
    @previous_attributes = previous_similar_transaction(transaction_history)
  end

  def recurring?
    self.frequency > 2
  end


  def_delegator :@company, :domain, :company_domain
  def_delegator :@company, :logo, :company_logo
  def_delegator :@company, :name, :company_name
  def_delegator :@company, :description, :company_description

  private

  def previous_similar_transaction(transaction_history)
    return {} unless self.recurring?
    most_recents= transaction_history.find_all{ |t| self.amount == t.fetch(:amount) && self.name == t.fetch(:name) }
    return { name: most_recents[1].fetch(:name), amount: most_recents[1].fetch(:amount), date: most_recents[1].fetch(:date) }
  end

  def determine_frequency(transaction_history)
    transaction_history.count{ |t| self.amount == t.fetch(:amount) && self.name == t.fetch(:name) }
  end

end
