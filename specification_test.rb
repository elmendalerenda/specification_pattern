require 'minitest/autorun'
require './account'

class SpecificationTest < Minitest::Test
  def test_select_payrolls
    payroll = "1.000,00,00;EUR;01/03/2015;payroll march"
    another_payroll = "1.000,00;EUR;02/04/2015;payroll april"
    transaction = "15,00;EUR;12/03/2015;prepaid topup"
    statement = [payroll, another_payroll, transaction]

    selected_transactions = Account.new(statement).payrolls

    assert_equal([payroll, another_payroll], selected_transactions)
  end

  def test_select_bank_fees
    fees = "5,00;EUR;01/03/2015;fees march"
    more_fees = "1,00;EUR;02/04/2015;fees april"
    payroll = "1.000,00;EUR;12/03/2015;payroll march"
    statement = [fees, more_fees, payroll]

    selected_transactions = Account.new(statement).fees

    assert_equal([fees, more_fees], selected_transactions)
  end

  def test_select_cash_withdrawal
    fees = "5,00;EUR;01/03/2015;fees march"
    withdrawal = "20,00;EUR;02/04/2015;cash withdrawal"
    payroll = "1.000,00;EUR;12/03/2015;payroll march"
    statement = [fees, withdrawal, payroll]

    selected_transactions = Account.new(statement).cash_withdrawals

    assert_equal([withdrawal], selected_transactions)
  end

  def test_select_payrolls_and_withdrawals
    fees = "5,00;EUR;01/03/2015;fees march"
    withdrawal = "20,00;EUR;02/04/2015;cash withdrawal"
    payroll = "1.000,00;EUR;12/03/2015;payroll march"
    statement = [fees, withdrawal, payroll]

    selected_transactions = Account.new(statement).select(Account::Payroll.and(Account::Withdrawal))

    assert_equal([payroll, withdrawal], selected_transactions)
  end
end
