# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Attachy::File, '#default' do
  context 'when config is missing' do
    before do
      allow(::Rails).to receive_message_chain(:application, :config_for) { nil }
    end

    specify { expect(described_class.default).to eq nil }
  end

  context 'when default image is present' do
    before do
      allow(::Rails).to receive_message_chain(:application, :config_for).with(:attachy) do
        {
          'default' => {
            'image' => {
              'public_id' => 'default',
              'format'    => 'png',
              'version'   => 1
            }
          }
        }
      end
    end

    it 'returns a new file object with the config values' do
      default = described_class.default

      expect(default).to           be_new_record
      expect(default.format).to    eq 'png'
      expect(default.public_id).to eq 'default'
      expect(default.version).to   eq '1'
    end
  end

  context 'when default image is not present' do
    before do
      allow(::Rails).to receive_message_chain(:application, :config_for).with(:attachy) do
        { 'default' => {} }
      end
    end

    specify { expect(described_class.default).to eq nil }
  end

  context 'when default image is not present' do
    before do
      allow(::Rails).to receive_message_chain(:application, :config_for).with(:attachy) { {} }
    end

    specify { expect(described_class.default).to eq nil }
  end
end
