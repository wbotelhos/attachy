# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, ':remove_tmp_tag' do
  let!(:user) { create :user }

  it 'removes the tmp tag via api' do
    expect(Cloudinary::Uploader).to receive(:remove_tag).with(Attachy::TMP_TAG, ['public_id'])

    create :file, public_id: 'public_id', attachable: user
  end
end
