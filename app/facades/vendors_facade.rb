class VendorsFacade
  def self.find_vendor(id)
    if Vendor.exists?(id: id)
      Vendor.find(id)
    else
      Error.new("Couldn't find Vendor with 'id'=#{id}", "NOT FOUND", 404)
    end
  end
end