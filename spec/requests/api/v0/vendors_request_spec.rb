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
end
