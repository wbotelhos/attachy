require 'rails_helper'

RSpec.describe Attachy::Viewer, '.content_options' do
  let!(:object)  { create :user }
  let!(:method)  { :avatar }
  let(:file)     { create :file, attachable: object, scope: method }
  let!(:options) { { t: { height: 600, width: 800 } } }

  before do
    allow(Cloudinary::Uploader).to receive(:remove_tag)

    allow(subject).to receive(:metadata) { { crop: :crop, multiple: :multiple } }
  end

  subject { described_class.new method, object, options }

  it 'returns the default field options' do
    expect(subject.content_options).to eq(
      class: :attachy__content,

      data: {
        crop:     :crop,
        height:   600,
        multiple: :multiple,
        width:    800
      }
    )
  end
end
