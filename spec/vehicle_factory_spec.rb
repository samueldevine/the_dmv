require 'spec_helper'

RSpec.describe VehicleFactory do
  before(:each) do
    @factory = VehicleFactory.new
    @wa_ev_registrations = DmvDataService.new.wa_ev_registrations
  end
  
  describe '#create_vehicles' do  
    it 'returns a list of Vehicle objects' do
      vehicles = @factory.create_vehicles(@wa_ev_registrations)
      expect(vehicles[0]).to be_an_instance_of(Vehicle)
      expect(vehicles[0].vin).to eq("1N4BZ0CP3G")
      expect(vehicles[0].year).to eq("2016")
      expect(vehicles[0].make).to eq("NISSAN")
      expect(vehicles[0].model).to eq("Leaf")
      expect(vehicles[0].engine).to eq(:ev)
      expect(vehicles[0].registration_date).to eq(nil)
      expect(vehicles[0].plate_type).to eq(nil)
    end
  end
end
