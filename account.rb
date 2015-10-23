class Account
  def initialize(statement)
    @statement = statement
  end

  def payrolls
    @statement.reject { |e| e !~ /payroll/ }
  end

  def fees
    @statement.reject { |e| e !~ /fees/ }
  end
end
