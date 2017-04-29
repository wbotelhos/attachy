# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Attachy::File, '#config' do
  before do
    allow(Rails.application).to receive(:config_for).with(:attachy) { :config }
  end

  it 'returns the config data' do
    expect(described_class.config).to eq :config
  end
end
