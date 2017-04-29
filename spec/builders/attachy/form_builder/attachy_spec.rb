# frozen_string_literal: true

require 'rails_helper'

class Dummy < ActionView::Helpers::FormBuilder
  include Attachy::FormBuilder
end

class DummyHelper
  include Attachy::ViewHelper
end

RSpec.describe Dummy, '.attachy' do
  let!(:method)   { :avatar }
  let!(:options)  { { key: :value } }
  let!(:object)   { create :user }
  let!(:template) { DummyHelper.new }
  let!(:dummy)    { described_class.new method, object, template, options }

  context 'with no block' do
    it 'delegates to view helper' do
      expect(template).to receive(:attachy).with(method, object, options, nil)

      dummy.attachy method, options
    end
  end

  context 'with block' do
    let!(:block) { proc {} }

    it 'delegates to view helper with block' do
      expect(template).to receive(:attachy).with(method, object, options, block)

      dummy.attachy method, options, &block
    end
  end
end
