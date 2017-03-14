require 'rails_helper'

RSpec.describe User, ':destroy_file' do
  let!(:user) { create :user }

  let!(:photo) do
    expect(Cloudinary::Uploader).to receive(:remove_tag)

    create :file, public_id: 'public_id', scope: :photos, attachable: user
  end

  context 'via assign' do
    context 'via assign on relation' do
      it 'removes the file via api' do
        expect(Cloudinary::Uploader).to receive(:destroy).with('public_id')

        user.photos_files = []
      end
    end

    context 'via assign on scope' do
      it 'removes the file via api' do
        expect(Cloudinary::Uploader).to receive(:destroy).with('public_id')

        user.photos = '[]'
      end
    end
  end

  context 'via method' do
    context 'via method over one record' do
      it 'removes the file via api' do
        expect(Cloudinary::Uploader).to receive(:destroy).with('public_id')

        user.photos_files.first.destroy
      end
    end

    context 'via method over criteria' do
      it 'removes the file via api' do
        expect(Cloudinary::Uploader).to receive(:destroy).with('public_id')

        user.photos_files.destroy_all
      end
    end

    context 'via .clear' do
      it 'does not removes the file via api' do
        expect(Cloudinary::Uploader).not_to receive(:destroy)

        user.photos_files.clear
      end
    end
  end
end
