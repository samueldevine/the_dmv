require 'spec_helper'

RSpec.describe Registrant do
  describe '#initialize' do
    it 'can initialize' do
      bruce = Registrant.new('Bruce', 18, true)
      expect(bruce).to be_an_instance_of(Registrant)
      expect(bruce.name).to eq('Bruce')
      expect(bruce.age).to eq(18)
      expect(bruce.permit?).to eq(true)
      expect(bruce.license_data).to eq({written: false, licence: false, renewed: false})
    end

    it 'initializes permit attr to false by default' do
      @penny = Registrant.new('Penny', 15)
      expect(@penny.permit?).to eq(false)
    end
  end

  describe '#earn_permit' do
    it 'grants a permit to the registrant' do
      @penny = Registrant.new('Penny', 15, false)
      expect(@penny.permit?).to eq(false)

      @penny.earn_permit
      expect(@penny.permit?).to eq(true)
    end
  end
end
