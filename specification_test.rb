require 'minitest/autorun'

class SpecificationTest < Minitest::Test
  def test_select_payrolls
    payroll = "1.000,00,00;EUR;01/03/2015;payroll march"
    another_payroll = "1.000,00;EUR;02/04/2015;payroll april"
    transaction = "15.00,00;EUR;12/03/2015;prepaid topup"
    statement = [payroll, another_payroll, transaction]

    selected_transactions = Account.new(statement).payrolls
    assert_equal([payroll, another_payroll], selected_transactions)
  end
end

class Account
  def initialize(statement)
    @statement = statement
  end

  def payrolls
    @statement.select {|e| !(e =~ /payroll/).nil? }
  end
end
