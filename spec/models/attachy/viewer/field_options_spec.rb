# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Attachy::Viewer, '.field_options' do
  subject { described_class.new method, object }

  let!(:object) { create :user }
  let!(:method) { :avatar }

  let!(:file) do
    allow(Cloudinary::Uploader).to receive(:remove_tag)

    create :file, attachable: object, scope: method
  end

  it 'returns the default field options' do
    expect(subject.field_options).to eq(class: :attachy)
  end
end
