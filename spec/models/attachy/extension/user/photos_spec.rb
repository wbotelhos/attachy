# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, ':photos' do
  before do
    allow(Cloudinary::Uploader).to receive(:remove_tag)
    allow(Cloudinary::Uploader).to receive(:destroy)
  end

  describe ':photos_files' do
    let!(:user)    { create :user }
    let!(:photo_1) { create :file, scope: :photos, attachable: user }
    let!(:photo_2) { create :file, scope: :photos, attachable: user }

    it 'returns all records' do
      expect(user.photos_files).to match_array [photo_1, photo_2]
    end
  end

  describe ':photos_files=' do
    let!(:user) { create :user }

    context 'when given records' do
      context 'already persisted' do
        let!(:photo_1) { create :file, scope: :photos }
        let!(:photo_2) { create :file, scope: :photos }

        before { user.photos_files = [photo_1, photo_2] }

        it 'references all' do
          expect(user.photos_files).to match_array [photo_1, photo_2]
        end
      end
    end

    context 'when given no records' do
      let!(:photo_1) { create :file, scope: :photo, attachable: user }
      let!(:photo_2) { create :file, scope: :photo, attachable: user }

      it 'clears all' do
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

  describe ':photos=' do
    let!(:user) { create :user }

    context 'with persisted record' do
      let!(:photo) { create :file, scope: :photos }

      context 'as a json' do
        let!(:json) { photo.to_json }

        it 'does not creates a new one' do
          user.photos = json

          expect { user.photos_files }.not_to change(Attachy::File, :count)
        end

        it 'is referenced' do
          user.photos = json

          expect(user.photos_files).to eq [photo]
        end
      end

      context 'as an array of json' do
        let!(:json) { [photo].to_json }

        it 'does not creates a new one' do
          user.photos = json

          expect { user.photos_files }.not_to change(Attachy::File, :count)
        end

        it 'is referenced' do
          user.photos = json

          expect(user.photos_files).to eq [photo]
        end
      end
    end

    context 'with no persisted record' do
      let!(:photo) do
        build(:file,
          format:    :jpg,
          height:    600,
          public_id: :public_id,
          scope:     :photo,
          width:     800)
      end

      context 'as a json' do
        let!(:json) { photo.to_json }

        it 'is saved and referenced' do
          user.photos = json

          expect(user.photos_files.size).to eq 1

          file = user.photos_files[0]

          expect(file.format).to    eq 'jpg'
          expect(file.height).to    eq 600
          expect(file.public_id).to eq 'public_id'
          expect(file.scope).to     eq 'photos'
          expect(file.width).to     eq 800
        end
      end

      context 'as an array of json' do
        let!(:json) { [photo].to_json }

        it 'is saved and referenced' do
          user.photos = json

          expect(user.photos_files.size).to eq 1

          file = user.photos_files[0]

          expect(file.format).to    eq 'jpg'
          expect(file.height).to    eq 600
          expect(file.public_id).to eq 'public_id'
          expect(file.scope).to     eq 'photos'
          expect(file.width).to     eq 800
        end
      end
    end

    context 'with an empty string' do
      let!(:photo) { create :file, scope: :photos, attachable: user }

      it 'does nothing' do
        user.photos = ''

        expect(user.photos_files).to eq [photo]
      end
    end

    context 'with an empty array as string' do
      let!(:photo) { create :file, scope: :photo, attachable: user }

      it 'clears the records' do
        user.photos = '[]'

        expect(user.photos_files).to eq []
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
      expect(user.photos_metadata).to eq(
        accept:   %i[jpg png],
        maximum:  10,
        multiple: true,
        scope:    :photos
      )
    end
  end
end
