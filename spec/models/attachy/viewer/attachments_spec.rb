# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Attachy::Viewer, '.attachments' do
  let!(:object) { create :user }

  before { allow(Cloudinary::Uploader).to receive(:remove_tag) }

  context 'with no files' do
    subject { described_class.new :avatar, object }

    specify { expect(subject.attachments).to eq [] }
  end

  context 'when is has one' do
    subject { described_class.new method, object }

    let!(:method) { :avatar }

    context 'and has no files' do
      specify { expect(subject.attachments).to eq [] }
    end

    context 'and has file' do
      let!(:file) { create :file, attachable: object, scope: method }

      it 'returns an array with this file' do
        expect(subject.attachments).to eq [file]
      end
    end
  end

  context 'when is has many' do
    subject { described_class.new method, object }

    let!(:method) { :photos }

    context 'and has no files' do
      specify { expect(subject.attachments).to eq [] }
    end

    context 'and has files' do
      let!(:file_1) { create :file, attachable: object, scope: method }
      let!(:file_2) { create :file, attachable: object, scope: method }

      it 'returns an array with this files' do
        expect(subject.attachments).to eq [file_1, file_2]
      end
    end
  end
end
