require 'spec_helper'

RSpec.describe Facility do
  before(:each) do
    @facility = Facility.new({name: 'DMV Tremont Branch', address: '2855 Tremont Place Suite 118 Denver CO 80205', phone: '(720) 865-4600'})
  end
  describe '#initialize' do
    it 'can initialize' do
      expect(@facility).to be_an_instance_of(Facility)
      expect(@facility.name).to eq('DMV Tremont Branch')
      expect(@facility.address).to eq('2855 Tremont Place Suite 118 Denver CO 80205')
      expect(@facility.phone).to eq('(720) 865-4600')
      expect(@facility.services).to eq([])
    end
  end

  describe '#add service' do
    it 'can add available services' do
      expect(@facility.services).to eq([])
      @facility.add_service('New Drivers License')
      @facility.add_service('Renew Drivers License')
      @facility.add_service('Vehicle Registration')
      expect(@facility.services).to eq(['New Drivers License', 'Renew Drivers License', 'Vehicle Registration'])
    end
  end

  describe '#register_vehicle' do
    it 'only works if the facility offers this service' do
      cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice} )
      expect(@facility.register_vehicle(cruz)).to eq(nil)

      @facility.add_service('Vehicle Registration')
      expect(@facility.register_vehicle(cruz)).to eq(cruz)
    end

    it "updates the facility's registered_vehicles and collected_fees" do
      cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice} )
      @facility.add_service('Vehicle Registration')
      expect(@facility.registered_vehicles).to eq([])
      expect(@facility.collected_fees).to eq(0)

      @facility.register_vehicle(cruz)

      expect(@facility.registered_vehicles).to eq([cruz])
      expect(@facility.collected_fees).to eq(100)
    end

    it "updates the vehicle's registration_date, and plate_type" do
      cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice} )
      @facility.add_service('Vehicle Registration')
      expect(cruz.registration_date).to eq(nil)
      expect(cruz.plate_type).to eq(nil)

      @facility.register_vehicle(cruz)
      expect(cruz.registration_date).to eq(Date.today)
      expect(cruz.plate_type).to eq(:regular)
    end

    it 'can register different types of vehicles' do
      cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice} )
      bolt = Vehicle.new({vin: '987654321abcdefgh', year: 2019, make: 'Chevrolet', model: 'Bolt', engine: :ev} )
      camaro = Vehicle.new({vin: '1a2b3c4d5e6f', year: 1969, make: 'Chevrolet', model: 'Camaro', engine: :ice} )
      @facility.add_service('Vehicle Registration')

      expect(@facility.collected_fees).to eq(0)

      @facility.register_vehicle(cruz)
      expect(@facility.collected_fees).to eq(100)
      expect(cruz.plate_type).to eq(:regular)

      @facility.register_vehicle(camaro)
      expect(@facility.collected_fees).to eq(125)
      expect(camaro.plate_type).to eq(:antique)

      @facility.register_vehicle(bolt)
      expect(@facility.collected_fees).to eq(325)
      expect(bolt.plate_type).to eq(:ev)
    end
  end

  describe '#administer_written_test' do
    before(:each) do
      @bruce = Registrant.new('Bruce', 18, true)
      @penny = Registrant.new('Penny', 16)
      @tucker = Registrant.new('Tucker', 15)
    end

    it 'can administer a written test' do
      expect(@facility.administer_written_test(@bruce)).to eq(false)
      expect(@bruce.license_data[:written]).to eq(false)

      @facility.add_service('Written Test')
      expect(@facility.administer_written_test(@bruce)).to eq(true)
      expect(@bruce.license_data[:written]).to eq(true)
    end

    it 'requires a permit and 16 years of age' do
      @facility.add_service('Written Test')

      expect(@facility.administer_written_test(@penny)).to eq(false)
      expect(@penny.license_data[:written]).to eq(false)

      @penny.earn_permit
      @tucker.earn_permit

      expect(@facility.administer_written_test(@penny)).to eq(true)
      expect(@penny.license_data[:written]).to eq(true)
      expect(@facility.administer_written_test(@tucker)).to eq(false)
      expect(@tucker.license_data[:written]).to eq(false)
    end
  end

  describe '#administer_road_test' do
    before(:each) do
      @bruce = Registrant.new('Bruce', 18, true)
      @facility.add_service('Written Test')
    end

    it 'can administer a road test' do
      @facility.administer_written_test(@bruce)
      expect(@facility.administer_road_test(@bruce)).to eq(false)

      @facility.add_service('Road Test')
      expect(@facility.administer_road_test(@bruce)).to eq(true)
      expect(@bruce.license_data).to eq({written: true, license: true, renewed: false})
    end

    it 'requires a written test first' do
      @facility.add_service('Road Test')
      expect(@facility.administer_road_test(@bruce)).to eq(false)

      @facility.administer_written_test(@bruce)
      expect(@facility.administer_road_test(@bruce)).to eq(true)
    end
  end

  describe '#renew_drivers_license' do
    it 'requires a current license' do
      bruce = Registrant.new('Bruce', 18, true)
      @facility.add_service('Written Test')
      @facility.add_service('Road Test')
      @facility.administer_written_test(bruce)
      @facility.administer_road_test(bruce)
      expect(bruce.license_data[:renewed]).to eq(false)

      @facility.renew_drivers_license(bruce)
      expect(bruce.license_data[:renewed]).to eq(false)

      @facility.add_service('Renew License')
      @facility.renew_drivers_license(bruce)
      expect(bruce.license_data[:renewed]).to eq(true)
    end
  end
end
