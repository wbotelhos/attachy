require 'rails_helper'

RSpec.describe Attachy::Viewer, '.value' do
  let!(:object) { create :user }

  context 'when has one result' do
    context 'as attachament' do
      let!(:method) { :avatar }
      let!(:file)   { create :file, attachable: object, scope: method }

      subject { described_class.new method, object }

      context 'and it is not default' do
        let!(:default) { Attachy::File.new public_id: 0 }

        before do
          allow(Attachy::File).to receive(:default) { default }
        end

        it 'is represented as an array of one json' do
          expect(subject.value).to eq [file].to_json
        end
      end

      context 'and it is default' do
        let!(:default) { Attachy::File.new public_id: file.public_id }

        before do
          allow(Attachy::File).to receive(:default) { default }
        end

        it 'ignores the virtual default value and returns an empty data' do
          expect(subject.value).to eq '[]'
        end
      end
    end

    context 'as attachaments' do
      let!(:method) { :photos }
      let!(:file)   { create :file, attachable: object, scope: method }

      subject { described_class.new method, object }

      context 'and it is not default' do
        let!(:default) { Attachy::File.new public_id: 0 }

        before do
          allow(Attachy::File).to receive(:default) { default }
        end

        it 'is represented as json' do
          expect(subject.value).to eq [file].to_json
        end
      end

      context 'and it is default' do
        let!(:default) { Attachy::File.new public_id: file.public_id }

        before do
          allow(Attachy::File).to receive(:default) { default }
        end

        it 'ignores the virtual default value and returns an empty data' do
          expect(subject.value).to eq '[]'
        end
      end
    end
  end

  context 'when has more than one result' do
    let!(:method) { :photos }
    let!(:file_1) { create :file, attachable: object, scope: :photos }
    let!(:file_2) { create :file, attachable: object, scope: :photos }

    subject { described_class.new method, object }

    it 'is represented as json' do
      expect(subject.value).to eq [file_1, file_2].to_json
    end
  end
end
