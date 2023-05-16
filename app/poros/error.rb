class Error
  attr_reader :detail, :status, :code

  def initialize(detail, status, code)
    @detail = detail
    @status = status
    @code = code
  end
end