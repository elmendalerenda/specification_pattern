class Account
  attr_reader :statement

  def initialize(statement)
    @statement = statement
  end

  def payrolls
    select_statements(/payroll/)
  end

  def fees
    select_statements(/fees/)
  end

  def cash_withdrawals
    select_statements(/withdrawal/)
  end

  def select(&spec)
    spec.call(@statement)
  end

  class PayrollSpec

    def and(other)
      -> (statement) { to_proc.call(statement) + other.to_proc.call(statement) }
    end

    def to_proc
      -> (statement) { statement.reject { |e| e !~ /payroll/ } }
    end
  end


  class WithdrawalSpec
    def to_proc
      -> (statement) { statement.reject { |e| e !~ /withdrawal/ } }
    end
  end

  Payroll = PayrollSpec.new
  Withdrawal = WithdrawalSpec.new

  private

  def select_statements(regex)
    @statement.reject { |e| e !~ regex }
  end
end
