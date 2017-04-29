# frozen_string_literal: true

require 'rails_helper'

class DummyHelper
  include Attachy::ViewHelper
end

RSpec.describe DummyHelper, '.attachy' do
  let!(:method)  { :avatar }
  let!(:options) { { key: :value } }
  let!(:object)  { create :user }
  let!(:helper)  { DummyHelper.new }
  let!(:viewer)  { double Attachy::Viewer, field: :field }

  context 'with no block' do
    before do
      allow(Attachy::Viewer).to receive(:new).with(method, object, options, helper) { viewer }
    end

    it 'calls field from viewer' do
      expect(helper.attachy(method, object, options, nil)).to eq :field
    end
  end

  context 'with block' do
    let!(:block) { proc { |v| expect(v.field).to eq :field } }

    before do
      allow(Attachy::Viewer).to receive(:new).with(method, object, options, helper) { viewer }
    end

    it 'delegates to view helper with block' do
      helper.attachy method, object, options, block
    end
  end
end
