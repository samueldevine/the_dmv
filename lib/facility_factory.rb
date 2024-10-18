class FacilityFactory
  def create_facilities(facilities_data)
    facilities_data.map do |f|
      data = parse_data(f)
      Facility.new(data)
    end
  end

  private

  def parse_data(facility_data)
    state = facility_data[:state]
    output = {}

    case state

    when 'CO'
      output[:name] = facility_data[:dmv_office]
      output[:address] = facility_data[:address_li]
      output[:phone] = format_phone_number(facility_data[:phone])

    when 'NY'
      output[:name] = facility_data[:office_name]
      output[:address] = facility_data[:street_address_line_1]
      output[:phone] = facility_data[:public_phone_number]

    when 'MO'
      output[:name] = facility_data[:name]
      output[:address] = facility_data[:address1]
      output[:phone] = format_phone_number(facility_data[:phone])
    end

    return output
  end

  def format_phone_number(phone_number)
    if !phone_number
      return nil
    end

    output = ""
    phone_number.each_char do |c|
      if c.match(/[0-9]/)
        output += c
      end
    end
    output
  end
end
