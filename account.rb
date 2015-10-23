class Account
  def initialize(statement)
    @statement = statement
  end

  def payrolls
    select(/payroll/)
  end

  def fees
    select(/fees/)
  end

  private

  def select(regex)
    @statement.reject { |e| e !~ regex }
  end
end
