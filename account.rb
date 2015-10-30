module AccountSpecs
  class Spec
    def and(other)
      -> (statement) { to_proc.call(statement) + other.to_proc.call(statement) }
    end

    def to_proc
      -> (statement) { each_transaction(statement) }
    end

    def satisfied_by?(transaction)
       true
    end

    private

    def each_transaction(statement)
      statement.select { |transaction| satisfied_by?(transaction) }
    end
  end

  class PayrollSpec < Spec
    def satisfied_by?(transaction)
       transaction =~ /payroll/
    end
  end

  class WithdrawalSpec < Spec
    def satisfied_by?(transaction)
       transaction =~ /withdrawal/
    end
  end

  class FeesSpec < Spec
    def satisfied_by?(transaction)
       transaction =~ /fees/
    end
  end
end

class Account
  Payroll = AccountSpecs::PayrollSpec.new
  Withdrawal = AccountSpecs::WithdrawalSpec.new
  Fees = AccountSpecs::FeesSpec.new

  def initialize(statement)
    @statement = statement
  end

  def payrolls
    select(&Payroll)
  end

  def fees
    select(&Fees)
  end

  def cash_withdrawals
    select(&Withdrawal)
  end

  def select(&spec)
    spec.call(@statement)
  end
end
