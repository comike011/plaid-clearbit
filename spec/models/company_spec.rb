require 'spec_helper'
require_relative '../../models/company.rb'

describe Company do
  let(:name) { 'Sonos' }
  let(:domain) { 'sonos.com' }
  let(:logo) { 'sonos.gif' }
  let(:description) { 'Speakers!' }
  describe '#initialize' do
    context 'when the domain is successfully retrieved' do
      before do
        clear_bit = double('clearbit')
        allow(Clearbit::NameDomain).to receive(:find).with({name: name}).and_return({'domain': domain })
        allow(Clearbit::Enrichment::Company).to receive(:find).with({domain: domain}).and_return({'logo': logo, 'description': description })
      end
      let!(:company) { Company.new(name) }
      it 'assigns the domain' do
        expect(company.name).to eq(name)
      end
      it 'assigns an enriched data attribute' do
        expect(company.enriched_data).not_to eq({})
      end
      it 'assigns a logo' do 
        expect(company.logo).to eq(logo)
      end
      it 'assigns a description' do
        expect(company.description).to eq(description)
      end
    end
    context 'when the domain is not successfully retrieved' do
      before do
        clear_bit = double('clearbit')
        allow(Clearbit::NameDomain).to receive(:find).with({name: name}).and_return(nil)
        #should not call the enrichment api
        expect(Clearbit::Enrichment::Company).not_to receive(:find)
      end
      let!(:company) { Company.new(name) }
      it 'populates the name passeed in' do
        expect(company.name).to eq(name)
      end
      it 'assigns "Unavailable" for the domain' do
        expect(company.domain).to eq("Unavailable")
      end
      it 'assigns an empty hash for enriched data' do
        expect(company.enriched_data).to eq({})
      end
      it 'assigns a default logo' do 
        expect(company.logo).to eq('notfound.png')
      end
      it 'assigns an default string to description' do
        expect(company.description).to eq("Company information could not be found for #{name}.")
      end
    end
  end
end
