require 'rails_helper'

RSpec.describe User, ':photos' do
  describe ':photos_files' do
    let!(:user)    { create :user }
    let!(:photo_1) { create :file, scope: :photos, attachable: user }
    let!(:photo_2) { create :file, scope: :photos, attachable: user }

    it 'returns all records' do
      expect(user.photos_files).to match_array [photo_1, photo_2]
    end
  end

  describe ':photos_files=' do
    let!(:user)    { create :user }
    let!(:photo_1) { create :file, scope: :photo }
    let!(:photo_2) { create :file, scope: :photo }

    context 'when given records' do
      before { user.photos_files = [photo_1, photo_2] }

      it 'is saved' do
        expect(user.photos_files).to match_array [photo_1, photo_2]
      end
    end

    context 'when given no records' do
      before { user.photos_files = [photo_1, photo_2] }

      it 'clears the existents' do
        user.photos_files = []

        expect(user.photos_files).to eq []
      end
    end
  end

  describe ':photo' do
    let!(:user) { create :user }

    context 'with no file' do
      it 'returns empty' do
        expect(user.photos).to eq []
      end
    end

    context 'with file' do
      let!(:photo_1) { create :file, scope: :photos, attachable: user }
      let!(:photo_2) { create :file, scope: :photos, attachable: user }

      it 'returns all records' do
        expect(user.photos).to match_array [photo_1, photo_2]
      end
    end
  end

  describe ':photo?' do
    let!(:user) { create :user }

    context 'with no records' do
      specify { expect(user.photos?).to eq false }
    end

    context 'with records' do
      before { create :file, scope: :photos, attachable: user }

      specify { expect(user.photos?).to eq true }
    end
  end

  describe ':photos_metadata' do
    let!(:user) { create :user }

    it 'returns the metadata' do
      expect(user.photos_metadata).to eq(accept: %i[jpg png], maximum: 10, has: :many, scope: :photos)
    end
  end
end
