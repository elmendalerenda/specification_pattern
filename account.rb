module AccountSpecs
  class Spec
    def or(other)
        new_class = Class.new(Spec) do
          attr_writer :one
          attr_writer :two
          def satisfied_by?(transaction)
            @one.satisfied_by?(transaction) || @two.satisfied_by?(transaction)
          end
        end
        ff = new_class.new
        ff.one = self
        ff.two = other
        ff
    end

    def and(other)
        new_class = Class.new(Spec) do
          attr_writer :one
          attr_writer :two
          def satisfied_by?(transaction)
            @one.satisfied_by?(transaction) && @two.satisfied_by?(transaction)
          end
        end
        ff = new_class.new
        ff.one = self
        ff.two = other
        ff
    end

    def satisfied_by?(transaction)
       true
    end

  end

  class PayrollSpec < Spec
    def satisfied_by?(transaction)
      transaction[:information] =~ /payroll/
    end
  end

  class WithdrawalSpec < Spec
    def satisfied_by?(transaction)
       transaction[:information] =~ /withdrawal/
    end
  end

  class FeesSpec < Spec
    def satisfied_by?(transaction)
       transaction[:information] =~ /fees/
    end
  end
  class AmountGreaterThanSpec < Spec
    def initialize(threshold)
      @threshold = threshold
    end

    def satisfied_by?(transaction)
       transaction[:amount] >= @threshold
    end
  end
end

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
