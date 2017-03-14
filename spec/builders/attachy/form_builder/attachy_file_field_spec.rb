require 'rails_helper'

class Dummy < ActionView::Helpers::FormBuilder
  include Attachy::FormBuilder
end

class DummyHelper
  include Attachy::ViewHelper
end

RSpec.describe Dummy, '.attachy_file_field' do
  let!(:method)   { :avatar }
  let!(:options)  { { key: :value } }
  let!(:object)   { create :user }
  let!(:template) { DummyHelper.new }
  let!(:dummy)    { described_class.new method, object, template, options }

  it 'delegates to view helper' do
    expect(template).to receive(:attachy_file_field).with(method, object, options)

    dummy.attachy_file_field method, options
  end
end
