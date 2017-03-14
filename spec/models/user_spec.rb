require 'rails_helper'

RSpec.describe User do
  it { expect(build(:user)).to be_valid }

  it { is_expected.to have_many(:avatar_files).conditions(scope: :avatar).class_name(Attachy::File).dependent :destroy }

  it { is_expected.to have_many(:photos_files).conditions(scope: :photos).class_name(Attachy::File).dependent :destroy }
end
