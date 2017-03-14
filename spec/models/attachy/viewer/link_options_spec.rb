require 'rails_helper'

RSpec.describe Attachy::Viewer, '.link_options' do
  let!(:object) { create :user }
  let!(:method) { :avatar }
  let!(:file)   { create :file, attachable: object, scope: method }

  subject { described_class.new method, object }

  it 'returns the default link options' do
    expect(subject.link_options).to eq(class: :attachy__link)
  end
end
