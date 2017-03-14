require 'rails_helper'

RSpec.describe Attachy::File, '#default' do
  before do
    allow(Rails.application).to receive(:config_for).with(:attachy) do
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
