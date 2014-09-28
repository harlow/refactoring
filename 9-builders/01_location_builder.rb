class LocationBuilder
  pattr_initialize [:location!]

  def geocode
    set_location_coordinates if geocodable?

    location
  end

  private

  def geocodable?
    location.address_field_values.any?(&:present?)
  end

  def set_location_coordinates
    location.latitude, location.longitude = geocode_address
  end

  def geocode_address
    GeocodingService.geocoder.coordinates(location.full_address)
  end
end
