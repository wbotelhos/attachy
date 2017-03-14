require 'rails_helper'

RSpec.describe Attachy::Viewer, '.node' do
  let!(:method)       { :avatar }
  let!(:object)       { create :user }
  let!(:file)         { create :file, attachable: object }
  let!(:viewer)       { described_class.new method, object, options }
  let!(:default_html) { { alt: :image, height: 50, width: 150 } }
  let!(:default_t)    { { height: 100, width: 200 } }
  let!(:options)      { { image: { t: default_t, html: default_html } } }

  describe 'default options' do
    before do
      allow(viewer).to receive(:link) { 'http://example.org' }
    end

    it 'adds the node options' do
      el = viewer.node

      expect(el).to have_tag :li, with: { class: 'attachy__node' }
    end
  end

  context 'when :ti is not given' do
    before do
      allow(viewer).to receive(:link).with(file, t: { crop: :none }, ti: default_t) { 'link' }
      allow(viewer).to receive(:remove_button) { 'remove' }
    end

    it 'builds the imagem with generic transform' do
      el = viewer.node

      expect(el).to have_tag :li do
        with_text 'linkremove'
      end
    end
  end

  context 'when :ti is given' do
    let!(:ti) { { height: 7, width: 17 } }

    before do
      allow(viewer).to receive(:link).with(file, t: { crop: :none }, ti: ti) { 'link' }
      allow(viewer).to receive(:remove_button) { 'remove' }
    end

    it 'builds the imagem with given transform' do
      el = viewer.node(ti: ti)

      expect(el).to have_tag :li do
        with_text 'linkremove'
      end
    end
  end

  context 'when :tl is not given' do
    before do
      allow(viewer).to receive(:link).with(file, t: { crop: :none }, ti: default_t) { 'link' }
      allow(viewer).to receive(:remove_button) { 'remove' }
    end

    it 'builds the node with no crop' do
      el = viewer.node

      expect(el).to have_tag :li do
        with_text 'linkremove'
      end
    end
  end

  context 'when :tl is given' do
    let!(:tl) { { height: 7, width: 17 } }

    before do
      allow(viewer).to receive(:link).with(file, t: tl, ti: default_t) { 'link' }
      allow(viewer).to receive(:remove_button) { 'remove' }
    end

    it 'builds the node with given transform' do
      el = viewer.node(tl: tl)

      expect(el).to have_tag :li do
        with_text 'linkremove'
      end
    end
  end

  context 'when :html is present' do
    let!(:html) { { invalid: :invalid } }

    before do
      allow(viewer).to receive(:link) { 'link' }
      allow(viewer).to receive(:remove_button) { 'remove' }
    end

    it 'builds the node with given html' do
      el = viewer.node(html: html)

      expect(el).to have_tag :li, with: html
    end
  end

  context 'when given a :file' do
    let!(:other_file) { create :file }

    before { allow(viewer).to receive(:remove_button) { 'remove' } }

    it 'builds the node with given html' do
      expect(viewer).to receive(:link).with(other_file, t: { crop: :none }, ti: default_t) { 'link' }

      el = viewer.node(other_file)

      expect(el).to have_tag :li do
        with_text 'linkremove'
      end
    end
  end

  context 'when a block is given' do
    let!(:html) { { target: :blank } }

    it 'yields the :html and :attachments' do
      viewer.node(html: html) do |htm, attachments|
        expect(attachments).to eq [file]
        expect(htm).to         eq({ target: :blank, class: :attachy__node })
      end
    end
  end
end
