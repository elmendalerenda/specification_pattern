require 'minitest/autorun'
require './account'

class SpecificationTest < Minitest::Test

  def setup
    @payroll = { amount: 1_000.00, currency: 'EUR', date: '12/03/2015', information:'payroll march' }
    @fees = { amount: 5.00, currency: 'EUR', date: '01/03/2015', information:'fees march' }
    @withdrawal = { amount: 20.00, currency: 'EUR', date: '02/04/2015', information:'cash withdrawal' }
  end

  def test_select_payrolls
    another_payroll = { amount: 1_000.00, currency: 'EUR', date: '12/04/2015', information:'payroll april' }
    statement = [@payroll, another_payroll, @fees]

    selected_transactions = Account.new(statement).payrolls

    assert_equal([@payroll, another_payroll], selected_transactions)
  end

  def test_select_bank_fees
    more_fees = { amount: 1.00, currency: 'EUR', date: '02/04/2015', information:'fees april' }
    statement = [@fees, more_fees, @payroll]

    selected_transactions = Account.new(statement).fees

    assert_equal([@fees, more_fees], selected_transactions)
  end

  def test_select_cash_withdrawal
    statement = [@fees, @withdrawal, @payroll]

    selected_transactions = Account.new(statement).cash_withdrawals

    assert_equal([@withdrawal], selected_transactions)
  end

  def test_select_payrolls_or_withdrawals
    statement = [@fees, @withdrawal, @payroll]

    selected_transactions = Account.new(statement).
      select(Account::Payroll.or(Account::Withdrawal))

    assert_equal([@withdrawal, @payroll], selected_transactions)
  end

  def test_select_amount_greater_than_500
    statement = [@withdrawal, @payroll]

    selected_transactions = Account.new(statement).
      select(Account::AmountGreaterThan500)

    assert_equal([@payroll], selected_transactions)
  end

  def test_select_amount_greater_than_500_and_payroll
    statement = [@withdrawal, @payroll]

    selected_transactions = Account.new(statement).
      select(Account::AmountGreaterThan500AndPayroll)

    assert_equal([@payroll], selected_transactions)
  end

  def test_select_amount_greater_than_500_and_payroll_or_withdrawal
    statement = [@withdrawal, @payroll, @fees]

    selected_transactions = Account.new(statement).
      select(Account::AmountGreaterThan500.
             and(Account::Payroll).
             or(Account::Withdrawal))

    assert_equal([@withdrawal, @payroll], selected_transactions)
  end
end
