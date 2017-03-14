require 'rails_helper'

RSpec.describe Attachy::Viewer, '.remove_button' do
  let!(:object) { create :user }
  let!(:method) { :avatar }
  let!(:file)   { create :file, attachable: object, scope: method }

  subject { described_class.new method, object }

  context 'when give no html options' do
    it 'returns just the default options' do
      el = subject.remove_button

      expect(el).to have_tag :span, with: { class: 'attachy__remove' } do
        with_text 'x'
      end
    end
  end

  context 'when give html options' do
    let!(:html) { { attribute: :value } }

    it 'merges with default options' do
      el = subject.remove_button(html: html)

      expect(el).to have_tag :span, with: { attribute: :value, class: 'attachy__remove' }
    end
  end

  context 'when a block is given' do
    let!(:html) { { target: :blank } }

    it 'yields the :html' do
      subject.remove_button(html: html) do |h|
        expect(h).to eq(target: :blank, class: :attachy__remove)
      end
    end
  end
end
