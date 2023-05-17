require 'rails_helper'

RSpec.describe Error do
  describe 'initialization' do
    it 'exists and has attributes' do
      error = Error.new("Test message", 404)

      expect(error).to be_an(Error)
      expect(error.message).to eq("Test message")
      expect(error.status_code).to eq(404)
    end
  end
end