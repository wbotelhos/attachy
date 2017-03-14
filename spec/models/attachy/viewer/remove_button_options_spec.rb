require 'rails_helper'

RSpec.describe Attachy::Viewer, '.remove_button_options' do
  let!(:object) { create :user }
  let!(:method) { :avatar }

  let!(:file) do
    allow(Cloudinary::Uploader).to receive(:remove_tag)

    create :file, attachable: object, scope: method
  end

  subject { described_class.new method, object }

  it 'returns the default remove button options' do
    expect(subject.remove_button_options).to eq(class: :attachy__remove)
  end
end
