# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Attachy::Viewer, '.button_label_options' do
  subject { described_class.new method, object }

  let!(:object) { create :user }
  let!(:method) { :avatar }
  let(:file)    { create :file, attachable: object, scope: method }

  before { allow(Cloudinary::Uploader).to receive(:remove_tag) }

  it 'returns the default button label options' do
    expect(subject.button_label_options).to eq(text: '...')
  end
end
