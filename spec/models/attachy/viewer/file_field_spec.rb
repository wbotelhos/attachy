# frozen_string_literal: true

require 'rails_helper'
require 'cloudinary'

RSpec.describe Attachy::Viewer, '.file_field' do
  subject { described_class.new method, object, options, view }

  let!(:method)  { :avatar }
  let!(:object)  { create :user }
  let!(:options) { {} }
  let!(:view)    { double }

  let!(:file) do
    allow(Cloudinary::Uploader).to receive(:remove_tag)

    create :file, attachable: object, scope: method
  end

  before { allow(subject).to receive(:file_field_options) { { key: :value } } }

  it 'returns the hidden field with attachments value' do
    allow(view).to receive(:cl_image_upload_tag).with(method, html: subject.file_field_options, tags: [Attachy::ENV_TAG, Attachy::TMP_TAG]) { :input }

    expect(subject.file_field).to eq :input
  end
end
