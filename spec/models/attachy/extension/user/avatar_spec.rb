require 'rails_helper'

RSpec.describe User, ':avatar' do
  before do
    allow(Cloudinary::Uploader).to receive(:remove_tag)
    allow(Cloudinary::Uploader).to receive(:destroy)
  end

  describe ':avatar_files' do
    let!(:user)     { create :user }
    let!(:avatar_1) { create :file, scope: :avatar, attachable: user }
    let!(:avatar_2) { create :file, scope: :avatar, attachable: user }

    it 'returns all records even in the singular' do
      expect(user.avatar_files).to match_array [avatar_1, avatar_2]
    end
  end

  describe ':avatar_files=' do
    let!(:user) { create :user }

    context 'when given records' do
      context 'already persisted' do
        let!(:avatar_1) { create :file, scope: :avatar }
        let!(:avatar_2) { create :file, scope: :avatar }

        before { user.avatar_files = [avatar_1, avatar_2] }

        it 'references all' do
          expect(user.avatar_files).to match_array [avatar_1, avatar_2]
        end
      end
    end

    context 'when given no records' do
      let!(:avatar_1) { create :file, scope: :avatar, attachable: user }
      let!(:avatar_2) { create :file, scope: :avatar, attachable: user }

      it 'clears all' do
        user.avatar_files = []

        expect(user.avatar_files).to eq []
      end
    end
  end

  describe ':avatar' do
    let!(:user) { create :user }

    context 'with no file' do
      before do
        allow(Attachy::File).to receive(:default) { :default }
      end

      it 'returns a default file' do
        expect(user.avatar).to eq :default
      end
    end

    context 'with file' do
      let!(:avatar_1) { create :file, scope: :avatar, attachable: user }
      let!(:avatar_2) { create :file, scope: :avatar, attachable: user }

      it 'returns just the last one simulating a has_one' do
        expect(user.avatar).to eq avatar_2
      end
    end
  end

  describe ':avatar=' do
    let!(:user) { create :user }

    context 'with persisted record' do
      let!(:avatar) { create :file, scope: :avatar }

      context 'as a json' do
        let!(:json) { avatar.to_json }

        it 'does not creates a new one' do
          user.avatar = json

          expect { user.avatar_files }.to_not change(Attachy::File, :count)
        end

        it 'is referenced' do
          user.avatar = json

          expect(user.avatar_files).to eq [avatar]
        end
      end

      context 'as an array of json' do
        let!(:json) { [avatar].to_json }

        it 'does not creates a new one' do
          user.avatar = json

          expect { user.avatar_files }.to_not change(Attachy::File, :count)
        end

        it 'is referenced' do
          user.avatar = json

          expect(user.avatar_files).to eq [avatar]
        end
      end
    end

    context 'with no persisted record' do
      let!(:avatar) do
        build(:file,
          format:    :jpg,
          height:    600,
          public_id: :public_id,
          scope:     :avatar,
          width:     800
        )
      end

      context 'as a json' do
        let!(:json) { avatar.to_json }

        it 'is saved and referenced' do
          user.avatar = json

          expect(user.avatar_files.size).to eq 1

          file = user.avatar_files[0]

          expect(file.format).to    eq 'jpg'
          expect(file.height).to    eq 600
          expect(file.public_id).to eq 'public_id'
          expect(file.scope).to     eq 'avatar'
          expect(file.width).to     eq 800
        end
      end

      context 'as an array of json' do
        let!(:json) { [avatar].to_json }

        it 'is saved and referenced' do
          user.avatar = json

          expect(user.avatar_files.size).to eq 1

          file = user.avatar_files[0]

          expect(file.format).to    eq 'jpg'
          expect(file.height).to    eq 600
          expect(file.public_id).to eq 'public_id'
          expect(file.scope).to     eq 'avatar'
          expect(file.width).to     eq 800
        end
      end
    end

    context 'with an empty string' do
      let!(:avatar) { create :file, scope: :avatar, attachable: user }

      it 'does nothing' do
        user.avatar = ''

        expect(user.avatar_files).to eq [avatar]
      end
    end

    context 'with an empty array as string' do
      let!(:avatar) { create :file, scope: :avatar, attachable: user }

      it 'clears the records' do
        user.avatar = '[]'

        expect(user.avatar_files).to eq []
      end
    end
  end

  describe ':avatar?' do
    let!(:user) { create :user }

    context 'with no records' do
      specify { expect(user.avatar?).to eq false }
    end

    context 'with records' do
      before { create :file, scope: :avatar, attachable: user }

      specify { expect(user.avatar?).to eq true }
    end
  end

  describe ':avatar_metadata' do
    let!(:user) { create :user }

    it 'returns the metadata' do
      expect(user.avatar_metadata).to eq(
        accept:   %i[jpg png],
        multiple: false,
        scope:    :avatar
      )
    end
  end
end
