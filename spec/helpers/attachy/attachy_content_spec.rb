require 'rails_helper'

class DummyHelper
  include Attachy::ViewHelper
end

RSpec.describe DummyHelper, '.attachy_content' do
  let!(:method)  { :avatar }
  let!(:options) { { key: :value } }
  let!(:object)  { create :user }
  let!(:helper)  { DummyHelper.new }
  let!(:viewer)  { double Attachy::Viewer, content: :content }

  before do
    allow(Attachy::Viewer).to receive(:new).with(method, object, options, helper) { viewer }
  end

  it 'calls content from viewer' do
    expect(helper.attachy_content(method, object, options)).to eq :content
  end
end
