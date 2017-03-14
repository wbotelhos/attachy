require 'rails_helper'

RSpec.describe Attachy::Viewer, '.field' do
  let!(:method)  { :avatar }
  let!(:object)  { create :user }
  let!(:file)    { create :file, attachable: object }
  let!(:options) { { button: { html: { key: :value } } } }

  before do
    allow(subject).to receive(:content)     { '1' }
    allow(subject).to receive(:file_button) { '2' }
  end

  subject { described_class.new method, object, options }

  describe 'default options' do
    it 'uses generic button options' do
      el = subject.field

      expect(el).to have_tag :div, with: { class: 'attachy' }
    end

    it 'builds a content based on content and file field' do
      el = subject.field

      expect(el).to have_tag :div do
        with_text '12'
      end
    end
  end

  context 'when :html is present' do
    let!(:html) { { key: :value } }

    it 'merges with default' do
      el = subject.field(html: html)

      expect(el).to have_tag :div, with: { class: 'attachy', key: 'value' }
    end
  end

  context 'when a block is given' do
    let!(:html) { { key: :value } }

    it 'yields the :html options' do
      subject.field(html: html) do |htm|
        expect(htm).to eq({ key: :value, class: :attachy })
      end
    end
  end
end
