require 'rails_helper'

RSpec.describe Attachy::Viewer, '.file_field' do
  let!(:object) { create :user }
  let!(:method) { :avatar }
  let!(:file)   { create :file, attachable: object, scope: method }
  let!(:view)   { double }

  before { allow(subject).to receive(:file_field_options) { { key: :value } } }

  subject { described_class.new method, object, view: view }

  it 'returns the hidden field with attachments value' do
    expect(view).to receive(:cl_image_upload_tag).with(method, html: subject.file_field_options) { :input }

    expect(subject.file_field).to eq :input
  end
end
