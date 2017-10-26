# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Attachy::File, '#config' do
  context 'when config does not exist' do
    it 'returns the config data' do
      expect(described_class.config).to eq nil
    end
  end

  context 'when config exists' do
    let!(:application) { double }

    before do
      allow(Rails).to receive(:application) { application }
      allow(application).to receive(:config_for).with(:attachy) { :config }
    end

    it 'returns the config data' do
      expect(described_class.config).to eq :config
    end
  end
end
