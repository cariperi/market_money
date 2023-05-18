class AtmSerializer
  include JSONAPI::Serializer

  set_id :id
  attributes :name,
             :address,
             :lat,
             :lon,
             :distance
end
