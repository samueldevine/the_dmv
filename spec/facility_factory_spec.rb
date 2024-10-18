require 'spec_helper'

RSpec.describe FacilityFactory do
  before(:each) do
    @factory = FacilityFactory.new
    @dmv_data_service = DmvDataService.new
    @co_dmv_office_locations = @dmv_data_service.co_dmv_office_locations
    @ny_dmv_office_locations = @dmv_data_service.ny_dmv_office_locations
    @mo_dmv_office_locations = @dmv_data_service.mo_dmv_office_locations
  end

  describe '#create_facilities' do
    it 'creates CO Facility objects from data' do
      co_facilities = @factory.create_facilities(@co_dmv_office_locations)
      expect(co_facilities).to be_an_instance_of(Array)
      expect(co_facilities[0]).to be_an_instance_of(Facility)
      expect(co_facilities[0].name).to eq('DMV Tremont Branch')
      expect(co_facilities[0].address).to eq('2855 Tremont Place')
      expect(co_facilities[0].phone).to eq('7208654600')
    end

    it 'creates NY Facility objects from data' do
      ny_facilities = @factory.create_facilities(@ny_dmv_office_locations)
      expect(ny_facilities).to be_an_instance_of(Array)
      expect(ny_facilities[0]).to be_an_instance_of(Facility)
      expect(ny_facilities[0].name).to eq('LAKE PLACID')
      expect(ny_facilities[0].address).to eq('2693 MAIN STREET')
      expect(ny_facilities[0].phone).to eq(nil)
      expect(ny_facilities[1].phone).to eq('5188283350')
    end

    it 'creates MO Facility objects from data' do
      mo_facilities = @factory.create_facilities(@mo_dmv_office_locations)
      expect(mo_facilities).to be_an_instance_of(Array)
      expect(mo_facilities[0]).to be_an_instance_of(Facility)
      expect(mo_facilities[0].name).to eq('FERGUSON-OFFICE CLOSED UNTIL FURTHER NOTICE')
      expect(mo_facilities[0].address).to eq('10425 WEST FLORISSANT')
      expect(mo_facilities[0].phone).to eq('3147335316')
    end
  end
end
