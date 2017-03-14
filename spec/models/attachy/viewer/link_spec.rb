require 'rails_helper'

RSpec.describe Attachy::Viewer, '.link' do
  let!(:method)       { :avatar }
  let!(:object)       { create :user }
  let!(:file)         { create :file, attachable: object }
  let!(:viewer)       { described_class.new method, object, options }
  let!(:default_html) { { alt: :image, height: 50, width: 150 } }
  let!(:default_t)    { { height: 100, width: 200 } }
  let!(:options)      { { image: { t: default_t, html: default_html } } }

  describe 'default options' do
    before { allow_any_instance_of(Attachy::File).to receive(:url).with(crop: :none) { 'http://example.org' } }

    it 'adds the link options' do
      expect(viewer).to receive(:image).with(file, t: default_t) { :image }

      el = viewer.link

      expect(el).to have_tag :a, with: { class: 'attachy__link' }
    end
  end

  context 'when :ti is not given' do
    before { allow_any_instance_of(Attachy::File).to receive(:url) { 'http://example.org' } }

    it 'builds the imagem with generic transform' do
      expect(viewer).to receive(:image).with(file, t: default_t) { :image }

      el = viewer.link

      expect(el).to have_tag :a do
        with_text 'image'
      end
    end
  end

  context 'when :ti is given' do
    let!(:ti) { { height: 7, width: 17 } }

    before { allow_any_instance_of(Attachy::File).to receive(:url) { 'http://example.org' } }

    it 'builds the imagem with given transform' do
      expect(viewer).to receive(:image).with(file, t: ti) { :image }

      el = viewer.link(ti: ti)

      expect(el).to have_tag :a do
        with_text 'image'
      end
    end
  end

  context 'when :t is not given' do
    before { allow_any_instance_of(Attachy::File).to receive(:url).with(crop: :none) { 'http://example.org' } }

    it 'builds the link url with :crop :none' do
      expect(viewer).to receive(:image).with(file, t: default_t) { :image }

      el = viewer.link

      expect(el).to have_tag :a, with: { href: 'http://example.org' }
    end

    it 'adds it on data attributes' do
      expect(viewer).to receive(:image).with(file, t: default_t) { :image }

      el = viewer.link

      expect(el).to have_tag :a, with: { 'data-crop' => 'none' }
    end
  end

  context 'when :t is given' do
    let!(:t) { { height: 4, width: 8 } }

    before { allow_any_instance_of(Attachy::File).to receive(:url).with(t) { 'http://example.org' } }

    it 'builds the link url with given transform' do
      expect(viewer).to receive(:image).with(file, t: default_t) { :image }

      el = viewer.link(t: t)

      expect(el).to have_tag :a, with: { href: 'http://example.org' }
    end
  end

  context 'when :html is present' do
    let!(:html) { { invalid: :invalid, target: :blank } }

    before { allow_any_instance_of(Attachy::File).to receive(:url) { 'http://example.org' } }

    it 'is added to html attributes' do
      allow(viewer).to receive(:image) { :image }

      el = viewer.link(html: html)

      expect(el).to have_tag 'a', with: { invalid: 'invalid', target: 'blank' }
    end
  end

  context 'when given a :file' do
    let!(:file) { create :file }

    it 'is used' do
      expect(file).to receive(:url).twice { 'http://example.org' }

      viewer.link file
    end
  end

  context 'when a block is given' do
    let!(:html) { { target: :blank } }
    let!(:t)    { { width: 10 } }

    it 'yields the :html and :attachments' do
      viewer.link(t: t, html: html) do |htm, attachments|
        expect(attachments).to eq [file]
        expect(htm).to         eq(data: { width: 10 }, target: :blank, class: :attachy__link)
      end
    end
  end
end
