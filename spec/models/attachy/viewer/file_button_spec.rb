# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Attachy::Viewer, '.file_button' do
  subject { described_class.new method, object, options }

  let!(:method)  { :avatar }
  let!(:object)  { create :user }
  let!(:options) { { button: { html: { key: :value } } } }

  let!(:file) do
    allow(Cloudinary::Uploader).to receive(:remove_tag)

    create :file, attachable: object
  end

  before do
    allow(subject).to receive(:button_label) { '1' }
    allow(subject).to receive(:file_field)   { '2' }
    allow(subject).to receive(:hidden_field) { '3' }
  end

  describe 'default options' do
    it 'uses generic button options' do
      el = subject.file_button

      expect(el).to have_tag :div, with: { class: 'attachy__button', key: :value }
    end

    it 'builds a content based on button label, file field and hidden field' do
      el = subject.file_button

      expect(el).to have_tag :div do
        with_text '123'
      end
    end
  end

  context 'when :html is present' do
    let!(:html) { { key: :value } }

    it 'merges with default' do
      el = subject.file_button

      expect(el).to have_tag :div, with: { class: 'attachy__button', key: :value }
    end
  end

  context 'when a block is given' do
    let!(:html) { { key: :value } }

    it 'yields the :html options' do
      subject.file_button(html: html) do |htm|
        expect(htm).to eq(key: :value, class: :attachy__button)
      end
    end
  end
end
