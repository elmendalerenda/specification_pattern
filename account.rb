class Account
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

  def select(spec)
  end

  class Payroll
    def self.and(spec)

    end
  end

  class Withdrawal
  end

  private

  def select_statements(regex)
    @statement.reject { |e| e !~ regex }
  end

end
