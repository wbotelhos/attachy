# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Attachy::Viewer, '.nodes' do
  subject { described_class.new method, object }

  let!(:object) { create :user }
  let!(:method) { :photos }
  let(:file_1)  { create :file, attachable: object, scope: method }
  let(:file_2)  { create :file, attachable: object, scope: method }

  before do
    allow(Cloudinary::Uploader).to receive(:remove_tag)

    allow(subject).to receive(:node).with(file_1) { :node_1 }
    allow(subject).to receive(:node).with(file_2) { :node_2 }
  end

  it 'returns the nodes with links inside as an array' do
    expect(subject.nodes).to eq %i[node_1 node_2]
  end
end
