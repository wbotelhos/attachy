require 'rails_helper'

RSpec.describe Attachy::File, '.transform' do
  context 'when crop is :none' do
    let!(:file) { build :file }

    it 'removes :crop, :height and :width' do
      expect(file.transform(crop: :none, key: :value)).to eq(
        format:    file.format,
        key:       :value,
        public_id: file.public_id,
        secure:    true,
        sign_url:  true,
        version:   file.version
      )
    end
  end

  context 'when crop is not :none' do
    describe ':crop' do
      context 'when not given' do
        specify { expect(subject.transform[:crop]).to eq :fill }
      end

      context 'with given' do
        specify { expect(subject.transform(crop: :scale)[:crop]).to eq :scale }
      end
    end

    describe ':format' do
      context 'when not given' do
        let!(:file) { described_class.new format: :png }

        it 'uses the file one' do
          expect(file.transform[:format]).to eq 'png'
        end
      end

      context 'when given' do
        let!(:file) { described_class.new format: :png }

        it 'uses the file one' do
          expect(file.transform(format: :gif)[:format]).to eq :gif
        end
      end
    end

    describe ':secure' do
      context 'when not given' do
        specify { expect(subject.transform[:secure]).to eq true }
      end

      context 'when not given' do
        specify { expect(subject.transform(secure: false)[:secure]).to eq false }
      end
    end

    describe ':sign_url' do
      context 'when given' do
        specify { expect(subject.transform[:sign_url]).to eq true }
      end

      context 'when not given' do
        specify { expect(subject.transform(sign_url: false)[:sign_url]).to eq false }
      end
    end

    describe ':version' do
      context 'when not given' do
        let!(:file) { described_class.new version: 42 }

        it 'uses the file one' do
          expect(file.transform[:version]).to eq '42'
        end
      end

      context 'when given' do
        let!(:file) { described_class.new version: 42 }

        it 'uses the file one' do
          expect(file.transform(version: 7)[:version]).to eq 7
        end
      end
    end
  end
end
