# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Attachy::Viewer, '.hidden_field' do
  subject { described_class.new method, object }

  let!(:object) { create :user }
  let!(:method) { :avatar }

  let!(:file) do
    allow(Cloudinary::Uploader).to receive(:remove_tag)

    create :file, attachable: object, scope: method
  end

  before { allow(subject).to receive(:value) { :value } }

  it 'returns the hidden field with attachments value' do
    el = subject.hidden_field

    expect(el).to have_tag :input, with: { name: 'user[avatar]', type: 'hidden', value: 'value' }
  end
end
