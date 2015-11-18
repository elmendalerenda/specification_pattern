require 'minitest/autorun'
require './account'

class SpecificationTest < Minitest::Test
  def test_select_payrolls
    payroll = { amount: 1_000.00, currency: 'EUR', date: '12/03/2015', information:'payroll march' }
    another_payroll = { amount: 1_000.00, currency: 'EUR', date: '12/04/2015', information:'payroll april' }
    transaction = { amount: 15.00, currency: 'EUR', date: '12/03/2015', information:'prepaid topup' }
    statement = [payroll, another_payroll, transaction]

    selected_transactions = Account.new(statement).payrolls

    assert_equal([payroll, another_payroll], selected_transactions)
  end

  def test_select_bank_fees
    fees = { amount: 5.00, currency: 'EUR', date: '01/03/2015', information:'fees march' }
    more_fees = { amount: 1.00, currency: 'EUR', date: '02/04/2015', information:'fees april' }
    payroll = { amount: 1_000.00, currency: 'EUR', date: '12/03/2015', information:'payroll march' }
    statement = [fees, more_fees, payroll]

    selected_transactions = Account.new(statement).fees

    assert_equal([fees, more_fees], selected_transactions)
  end

  def test_select_cash_withdrawal
    fees = { amount: 5.00, currency: 'EUR', date: '01/03/2015', information:'fees march' }
    withdrawal = { amount: 20.00, currency: 'EUR', date: '02/04/2015', information:'cash withdrawal' }
    payroll = { amount: 1_000.00, currency: 'EUR', date: '12/03/2015', information:'payroll march' }
    statement = [fees, withdrawal, payroll]

    selected_transactions = Account.new(statement).cash_withdrawals

    assert_equal([withdrawal], selected_transactions)
  end

  def test_select_payrolls_or_withdrawals
    fees = { amount: 5.00, currency: 'EUR', date: '01/03/2015', information:'fees march' }
    withdrawal = { amount: 20.00, currency: 'EUR', date: '02/04/2015', information:'cash withdrawal' }
    payroll = { amount: 1_000.00, currency: 'EUR', date: '12/03/2015', information:'payroll march' }
    statement = [fees, withdrawal, payroll]

    selected_transactions = Account.new(statement).select(Account::Payroll.or(Account::Withdrawal))

    assert_equal([withdrawal, payroll], selected_transactions)
  end

  def test_select_amount_greater_than_500
    withdrawal = { amount: 20.00, currency: 'EUR', date: '02/04/2015', information:'cash withdrawal' }
    payroll = { amount: 1_000.00, currency: 'EUR', date: '12/03/2015', information:'payroll march' }
    statement = [withdrawal, payroll]

    selected_transactions = Account.new(statement).select(Account::AmountGreaterThan500)

    assert_equal([payroll], selected_transactions)
  end

  def test_select_amount_greater_than_500_and_payroll
    withdrawal = { amount: 1_000.00, currency: 'EUR', date: '02/04/2015', information:'cash withdrawal' }
    payroll = { amount: 1_000.00, currency: 'EUR', date: '12/03/2015', information:'payroll march' }
    statement = [withdrawal, payroll]

    selected_transactions = Account.new(statement).select(Account::AmountGreaterThan500AndPayroll)

    assert_equal([payroll], selected_transactions)
  end

  def test_select_amount_greater_than_500_and_payroll_or_withdrawal
    withdrawal = { amount: 1_000.00, currency: 'EUR', date: '02/04/2015', information:'cash withdrawal' }
    payroll = { amount: 1_000.00, currency: 'EUR', date: '12/03/2015', information:'payroll march' }
    fees = { amount: 5.00, currency: 'EUR', date: '01/03/2015', information:'fees march' }
    statement = [withdrawal, payroll, fees]

    selected_transactions = Account.new(statement).
      select(Account::AmountGreaterThan500.
             and(Account::Payroll).
             or(Account::Withdrawal))

    assert_equal([withdrawal, payroll], selected_transactions)
  end
end
