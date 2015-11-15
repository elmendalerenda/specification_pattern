module AccountSpecs
  class Spec
    def or(other)
      -> (statement) { to_proc.call(statement) + other.to_proc.call(statement) }
    end

    def and(other)
      -> (statement) {

        f1 = to_proc.call(statement)
        f2 = other.to_proc.call(statement)

        dd = []
        f1.each {|e|
          f2.each{|i|
            if(e[:information] == i[:information])
              dd << i
            end
          }
        }

        dd
        }
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
