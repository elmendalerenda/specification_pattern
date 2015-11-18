require './account_specs'

class Account
  Payroll = AccountSpecs::PayrollSpec.new
  Withdrawal = AccountSpecs::WithdrawalSpec.new
  Fees = AccountSpecs::FeesSpec.new
  AmountGreaterThan500 = AccountSpecs::AmountGreaterThanSpec.new(500.0)
  AmountGreaterThan500AndPayroll = Account::AmountGreaterThan500.and(Account::Payroll)

  def initialize(statement)
    @statement = statement
  end

  def payrolls
    select(Payroll)
  end

  def fees
    select(Fees)
  end

  def cash_withdrawals
    select(Withdrawal)
  end

  def select(spec)
    @statement.select { |e| spec.satisfied_by?(e) }
  end
end
