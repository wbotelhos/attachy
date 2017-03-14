require 'rails_helper'

RSpec.describe Attachy::Viewer, '.file_field_options' do
  let!(:object) { create :user }
  let!(:method) { :avatar }
  let!(:file)   { create :file, attachable: object, scope: method }

  subject { described_class.new method, object }

  context 'when :accept has invalid mime type' do
    context 'with one type' do
      before do
        allow(subject).to receive(:metadata) { { accept: :abc } }
      end

      it 'does not added as attribute' do
        el = subject.file_field_options

        expect(el).to eq(class: :attachy__fileupload)
      end
    end

    context 'with more than one type' do
      before do
        allow(subject).to receive(:metadata) { { accept: [:abc, :png] } }
      end

      it 'is added as attribute only the valid one' do
        el = subject.file_field_options

        expect(el).to eq(accept: 'image/png', class: :attachy__fileupload)
      end
    end
  end

  context 'when :accept is a valid mime type' do
    context 'with one type' do
      before do
        allow(subject).to receive(:metadata) { { accept: :jpg } }
      end

      it 'is added as attribute' do
        el = subject.file_field_options

        expect(el).to eq(accept: 'image/jpeg', class: :attachy__fileupload)
      end
    end

    context 'with more than one type' do
      before do
        allow(subject).to receive(:metadata) { { accept: [:jpg, :png] } }
      end

      it 'is added as attribute' do
        el = subject.file_field_options

        expect(el).to eq(accept: 'image/jpeg,image/png', class: :attachy__fileupload)
      end
    end
  end

  context 'when :multiple is true' do
    before do
      allow(subject).to receive(:metadata) { { multiple: true } }
    end

    it 'turns the field multiple' do
      el = subject.file_field_options

      expect(el).to eq(multiple: true, class: :attachy__fileupload)
    end
  end

  context 'when :multiple is false' do
    before do
      allow(subject).to receive(:metadata) { { multiple: false } }
    end

    it 'does not adds the multiple attribute' do
      el = subject.file_field_options

      expect(el).to eq(class: :attachy__fileupload)
    end
  end
end
