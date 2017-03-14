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
    let!(:user)     { create :user }
    let!(:avatar_1) { create :file, scope: :avatar }
    let!(:avatar_2) { create :file, scope: :avatar }

    context 'when given records' do
      before { user.avatar_files = [avatar_1, avatar_2] }

      it 'is saved' do
        expect(user.avatar_files).to match_array [avatar_1, avatar_2]
      end
    end

    context 'when given no records' do
      before { user.avatar_files = [avatar_1, avatar_2] }

      it 'clears the existents' do
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
