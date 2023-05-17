require 'rails_helper'

describe 'Vendor Endpoints' do
  describe 'Get One Vendor' do
    it 'can get one vendor by its id' do
      vendor_1 = create(:vendor)
      vendor_2 = create(:vendor)

      get "/api/v0/vendors/#{vendor_1.id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:data)

      vendor = data[:data]
      expect(vendor).to be_a(Hash)

      expect(vendor).to have_key(:id)
      expect(vendor[:id]).to be_a(String)
      expect(vendor[:id]).to eq(vendor_1.id.to_s)

      expect(vendor).to have_key(:type)
      expect(vendor[:type]).to be_a(String)
      expect(vendor[:type]).to eq('vendor')

      expect(vendor).to have_key(:attributes)
      expect(vendor[:attributes]).to be_a(Hash)

      attributes = vendor[:attributes]

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
      expect(attributes[:name]).to eq(vendor_1.name)

      expect(attributes).to have_key(:description)
      expect(attributes[:description]).to be_a(String)
      expect(attributes[:description]).to eq(vendor_1.description)

      expect(attributes).to have_key(:contact_name)
      expect(attributes[:contact_name]).to be_a(String)
      expect(attributes[:contact_name]).to eq(vendor_1.contact_name)

      expect(attributes).to have_key(:contact_phone)
      expect(attributes[:contact_phone]).to be_a(String)
      expect(attributes[:contact_phone]).to eq(vendor_1.contact_phone)

      expect(attributes).to have_key(:credit_accepted)
      expect(attributes[:credit_accepted]).to be_in([true, false])
      expect(attributes[:credit_accepted]).to eq(vendor_1.credit_accepted)
    end

    it 'returns an error if an invalid market id is passed in' do

      get "/api/v0/vendors/5"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:errors)

      error = data[:errors][0][:detail]
      expect(error).to eq("Couldn't find Vendor with 'id'=5")
    end
  end

  describe 'Create a Vendor' do
    it 'can create a new vendor if all attributes are provided' do
      vendor_params = ({
                  name: 'Vendor 1',
                  description: 'A good vendor.',
                  contact_name: 'Jane Doe',
                  contact_phone: '(123)456-7890',
                  credit_accepted: true
                })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      created_vendor = Vendor.last
      expect(created_vendor.name).to eq(vendor_params[:name])
      expect(created_vendor.description).to eq(vendor_params[:description])
      expect(created_vendor.contact_name).to eq(vendor_params[:contact_name])
      expect(created_vendor.contact_phone).to eq(vendor_params[:contact_phone])
      expect(created_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])

      expect(response).to be_successful
      expect(response.status).to eq(201)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:data)

      vendor = data[:data]
      expect(vendor).to be_a(Hash)

      expect(vendor).to have_key(:id)
      expect(vendor[:id]).to be_a(String)
      expect(vendor[:id]).to eq(created_vendor.id.to_s)

      expect(vendor).to have_key(:type)
      expect(vendor[:type]).to be_a(String)
      expect(vendor[:type]).to eq('vendor')

      expect(vendor).to have_key(:attributes)
      expect(vendor[:attributes]).to be_a(Hash)

      attributes = vendor[:attributes]

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
      expect(attributes[:name]).to eq(created_vendor.name)

      expect(attributes).to have_key(:description)
      expect(attributes[:description]).to be_a(String)
      expect(attributes[:description]).to eq(created_vendor.description)

      expect(attributes).to have_key(:contact_name)
      expect(attributes[:contact_name]).to be_a(String)
      expect(attributes[:contact_name]).to eq(created_vendor.contact_name)

      expect(attributes).to have_key(:contact_phone)
      expect(attributes[:contact_phone]).to be_a(String)
      expect(attributes[:contact_phone]).to eq(created_vendor.contact_phone)

      expect(attributes).to have_key(:credit_accepted)
      expect(attributes[:credit_accepted]).to be_in([true, false])
      expect(attributes[:credit_accepted]).to eq(created_vendor.credit_accepted)
    end

    it 'sends a custom error if any attributes are not provided' do
      vendor_params = ({
        name: 'Vendor 1',
        description: 'A good vendor.',
        credit_accepted: true
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:errors)

      error = data[:errors][0][:detail]
      expect(error).to eq("Validation failed: Contact name can't be blank, Contact phone can't be blank")
    end
  end

  describe 'Update a Vendor' do
    it 'can update an existing vendor if any attributes are changed' do
      vendor_1 = create(:vendor)
      original_name = vendor_1.name
      original_contact_name = vendor_1.contact_name
      original_credit_accepted = vendor_1.credit_accepted

      vendor_params = ({
                  description: 'A good vendor.',
                  contact_phone: '(123)456-7890'
                })
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v0/vendors/#{vendor_1.id}", headers: headers, params: JSON.generate(vendor: vendor_params)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:data)

      vendor = data[:data]
      expect(vendor).to be_a(Hash)

      expect(vendor).to have_key(:id)
      expect(vendor[:id]).to be_a(String)
      expect(vendor[:id]).to eq(vendor_1.id.to_s)

      expect(vendor).to have_key(:type)
      expect(vendor[:type]).to be_a(String)
      expect(vendor[:type]).to eq('vendor')

      expect(vendor).to have_key(:attributes)
      expect(vendor[:attributes]).to be_a(Hash)

      attributes = vendor[:attributes]

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
      expect(attributes[:name]).to eq(original_name)

      expect(attributes).to have_key(:description)
      expect(attributes[:description]).to be_a(String)
      expect(attributes[:description]).to eq(vendor_params[:description])

      expect(attributes).to have_key(:contact_name)
      expect(attributes[:contact_name]).to be_a(String)
      expect(attributes[:contact_name]).to eq(original_contact_name)

      expect(attributes).to have_key(:contact_phone)
      expect(attributes[:contact_phone]).to be_a(String)
      expect(attributes[:contact_phone]).to eq(vendor_params[:contact_phone])

      expect(attributes).to have_key(:credit_accepted)
      expect(attributes[:credit_accepted]).to be_in([true, false])
      expect(attributes[:credit_accepted]).to eq(original_credit_accepted)
    end

    it 'sends a custom error if any attributes are set to nil or empty' do
      vendor_1 = create(:vendor)

      vendor_params = ({
                  contact_name: "",
                  credit_accepted: false
                })
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v0/vendors/#{vendor_1.id}", headers: headers, params: JSON.generate(vendor: vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:errors)

      error = data[:errors][0][:detail]
      expect(error).to eq("Validation failed: Contact name can't be blank")
    end

    it 'sends a custom error if the vendor record does not exist' do
      vendor_params = ({
                  contact_name: "Jane Doe",
                  credit_accepted: false
                })
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v0/vendors/5", headers: headers, params: JSON.generate(vendor: vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:errors)

      error = data[:errors][0][:detail]
      expect(error).to eq("Couldn't find Vendor with 'id'=5")
    end
  end

  describe 'Delete a Vendor' do
    it 'can delete a vendor record and its associations when a valid id is passed in' do
      vendor_1 = create(:vendor)
      vendor_2 = create(:vendor)
      market_1 = create(:market)
      market_2 = create(:market)

      mv_1 = MarketVendor.create(market_id: market_1, vendor_id: vendor_1)
      mv_2 = MarketVendor.create(market_id: market_2, vendor_id: vendor_1)

      expect{ delete "/api/v0/vendors/#{vendor_1.id}" }.to change(Vendor, :count).by(-1)

      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(response.body).to eq("")

      expect{Vendor.find(vendor_1.id)}.to raise_error(ActiveRecord::RecordNotFound)
      expect{MarketVendor.find(mv_1.id)}.to raise_error(ActiveRecord::RecordNotFound)
      expect{MarketVendor.find(mv_2.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'sends a custom error if the vendor record does not exist' do
      delete "/api/v0/vendors/5"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:errors)

      error = data[:errors][0][:detail]
      expect(error).to eq("Couldn't find Vendor with 'id'=5")
    end
  end
end
