module AccountSpecs
  class Spec
    def or(other)
      OrOperatorSpec.new(self, other)
    end

    def and(other)
      AndOperatorSpec.new(self, other)
    end

    def satisfied_by?(transaction)
      true
    end
  end

  class CompositeSpec < Spec
    def initialize(a_spec, another_spec)
      @a_spec = a_spec
      @another_spec = another_spec
    end
  end

  class OrOperatorSpec < CompositeSpec
    def satisfied_by?(transaction)
      @a_spec.satisfied_by?(transaction) || @another_spec.satisfied_by?(transaction)
    end
  end

  class AndOperatorSpec < CompositeSpec
    def satisfied_by?(transaction)
      @a_spec.satisfied_by?(transaction) && @another_spec.satisfied_by?(transaction)
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
