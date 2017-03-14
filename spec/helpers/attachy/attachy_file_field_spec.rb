require 'rails_helper'

class DummyHelper
  include Attachy::ViewHelper
end

RSpec.describe DummyHelper, '.attachy_file_field' do
  let!(:method)  { :avatar }
  let!(:options) { { key: :value } }
  let!(:object)  { create :user }
  let!(:helper)  { DummyHelper.new }
  let!(:viewer)  { double Attachy::Viewer, file_field: :file_field }

  before do
    allow(Attachy::Viewer).to receive(:new).with(method, object, options, helper) { viewer }
  end

  it 'calls file_field from viewer' do
    expect(helper.attachy_file_field method, object, options).to eq :file_field
  end
end
