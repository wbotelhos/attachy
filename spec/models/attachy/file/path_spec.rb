require 'rails_helper'

RSpec.describe Attachy::File, '.url' do
  let!(:file)    { described_class.new public_id: :public_id }
  let!(:options) { { key: :value } }

  before do
    allow(file).to receive(:transform).with(options) { :transform }
  end

  it 'returns a cloudinary url' do
    expect(Cloudinary::Utils).to receive(:cloudinary_url).with('public_id', :transform) { :url }

    expect(file.url(key: :value)).to eq :url
  end
end
