require 'rails_helper'

describe 'Market Endpoints' do
  it 'sends a list of all markets' do
    create_list(:market, 3)

    get '/api/v0/markets'

    expect(response).to be_successful
    expect(response.status).to eq(200)
  end
end