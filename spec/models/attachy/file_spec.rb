# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Attachy::File do
  it { expect(build(:file)).to be_valid }

  it { is_expected.to belong_to :attachable }

  it { is_expected.to validate_presence_of :format }
  it { is_expected.to validate_presence_of :height }
  it { is_expected.to validate_presence_of :public_id }
  it { is_expected.to validate_presence_of :resource_type }
  it { is_expected.to validate_presence_of :scope }
  it { is_expected.to validate_presence_of :version }
end
