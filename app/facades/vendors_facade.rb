class VendorsFacade
  def self.find_vendor(id)
    if Vendor.exists?(id: id)
      Vendor.find(id)
    else
      Error.new("Couldn't find Vendor with 'id'=#{id}", "NOT FOUND", 404)
    end
  end

  def self.create_vendor(params)
    vendor = Vendor.new(params)
    if vendor.valid?
      vendor.save
      vendor
    else
      errors = vendor.errors.full_messages.join(", ")
      Error.new("Validation failed: #{errors}", "BAD REQUEST", 400)
    end
  end

  def self.update_vendor(id, params)
    vendor = find_vendor(id)
    return vendor if vendor.class != Vendor

    if vendor.update(params)
      vendor
    else
      errors = vendor.errors.full_messages.join(", ")
      Error.new("Validation failed: #{errors}", "BAD REQUEST", 400)
    end
  end
end