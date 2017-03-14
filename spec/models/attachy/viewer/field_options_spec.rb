require 'rails_helper'

RSpec.describe Attachy::Viewer, '.field_options' do
  let!(:object) { create :user }
  let!(:method) { :avatar }
  let!(:file)   { create :file, attachable: object, scope: method }

  subject { described_class.new method, object }

  it 'returns the default field options' do
    expect(subject.field_options).to eq(class: :attachy)
  end
end