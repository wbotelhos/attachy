require 'rails_helper'

RSpec.describe Attachy::Viewer, '.file_button_options' do
  let!(:object) { create :user }
  let!(:method) { :avatar }

  let!(:file) do
    allow(Cloudinary::Uploader).to receive(:remove_tag)

    create :file, attachable: object, scope: method
  end

  subject { described_class.new method, object }

  it 'returns the default file button options' do
    expect(subject.file_button_options).to eq(class: :attachy__button)
  end
end
