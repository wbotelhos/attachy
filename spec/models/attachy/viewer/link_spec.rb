require 'rails_helper'

RSpec.describe Attachy::Viewer, '.link' do
  let!(:method)       { :avatar }
  let!(:object)       { create :user }
  let!(:default_html) { { alt: :image, height: 50, width: 150 } }
  let!(:default_t)    { { height: 100, width: 200 } }
  let!(:options)      { { t: default_t, html: default_html } }

  let!(:file) do
    allow(Cloudinary::Uploader).to receive(:remove_tag)

    create :file, attachable: object
  end

  subject { described_class.new method, object, options }

  describe 'default options' do
    before do
      allow_any_instance_of(Attachy::File).to receive(:url).with(crop: :none) { 'http://example.org' }
    end

    it 'adds the link options' do
      expect(subject).to receive(:image).with(file, t: default_t) { :image }

      el = subject.link

      expect(el).to have_tag :a, with: { class: 'attachy__link' }
    end
  end

  context 'when :t is not given' do
    before { allow_any_instance_of(Attachy::File).to receive(:url) { 'http://example.org' } }

    it 'builds the imagem with generic transform' do
      expect(subject).to receive(:image).with(file, t: default_t) { :image }

      el = subject.link

      expect(el).to have_tag :a do
        with_text 'image'
      end
    end
  end

  context 'when :t is given' do
    let!(:t) { { height: 7, width: 17 } }

    before { allow_any_instance_of(Attachy::File).to receive(:url) { 'http://example.org' } }

    it 'builds the imagem with given transform' do
      expect(subject).to receive(:image).with(file, t: t) { :image }

      el = subject.link(t: t)

      expect(el).to have_tag :a do
        with_text 'image'
      end
    end
  end

  context 'when :t is not given' do
    before { allow_any_instance_of(Attachy::File).to receive(:url).with(crop: :none) { 'http://example.org' } }

    it 'builds the link url with :crop :none' do
      expect(subject).to receive(:image).with(file, t: default_t) { :image }

      el = subject.link

      expect(el).to have_tag :a, with: { href: 'http://example.org' }
    end

    it 'adds it on data attributes' do
      expect(subject).to receive(:image).with(file, t: default_t) { :image }

      el = subject.link

      expect(el).to have_tag :a, with: { 'data-crop' => 'none' }
    end
  end

  context 'when :tl is given' do
    let!(:tl) { { height: 4, width: 8 } }

    before { allow_any_instance_of(Attachy::File).to receive(:url).with(tl) { 'http://example.org' } }

    it 'builds the link url with given transform' do
      expect(subject).to receive(:image).with(file, t: default_t) { :image }

      el = subject.link(tl: tl)

      expect(el).to have_tag :a, with: { href: 'http://example.org' }
    end
  end

  context 'when :html is present' do
    let!(:html) { { invalid: :invalid, target: :blank } }

    before { allow_any_instance_of(Attachy::File).to receive(:url) { 'http://example.org' } }

    it 'is added to html attributes' do
      allow(subject).to receive(:image) { :image }

      el = subject.link(html: html)

      expect(el).to have_tag 'a', with: { invalid: 'invalid', target: 'blank' }
    end
  end

  context 'when given a :file' do
    let!(:file) { build :file }

    it 'is used' do
      expect(file).to receive(:url).twice { 'http://example.org' }

      subject.link file
    end
  end

  context 'when a block is given' do
    let!(:html) { { target: :blank } }
    let!(:tl)   { { width: 10 } }

    it 'yields the :html and :attachments' do
      subject.link(tl: tl, html: html) do |htm, attachments|
        expect(attachments).to eq [file]
        expect(htm).to         eq(data: { width: 10 }, target: :blank, class: :attachy__link)
      end
    end
  end
end
