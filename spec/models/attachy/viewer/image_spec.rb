require 'rails_helper'

RSpec.describe Attachy::Viewer, '.image' do
  let!(:method)       { :avatar }
  let!(:object)       { create :user }
  let!(:file)         { create :file, attachable: object }
  let!(:viewer)       { described_class.new method, object, options }
  let!(:default_html) { { alt: :image, height: 50, width: 150 } }
  let!(:default_t)    { { height: 100, width: 200 } }
  let!(:options)      { { image: { t: default_t, html: default_html } } }

  context 'when :html is present' do
    let!(:html_attributes) { { alt: :alt, invalid: :invalid, height: 11, width: 22 } }

    context 'and :t is blank' do
      let!(:t_attributes) { {} }

      before { allow_any_instance_of(Attachy::File).to receive(:url).with(t_attributes) { 'http://example.org' } }

      it 'adds all attributes on image' do
        el = viewer.image(t: t_attributes, html: html_attributes)

        expect(el).to have_tag 'img', with: html_attributes
      end
    end

    context 'and :t is present' do
      let!(:t_attributes) { { height: 1, width: 2 } }

      before { allow_any_instance_of(Attachy::File).to receive(:url).with(t_attributes) { 'http://example.org' } }

      it 'gives priority to :html' do
        el = viewer.image(t: t_attributes, html: html_attributes)

        expect(el).to have_tag 'img', with: html_attributes
      end
    end

    context 'and :t is not given' do
      before { allow_any_instance_of(Attachy::File).to receive(:url).with(default_t) { 'http://example.org' } }

      it 'uses the :html attributes and transform with default :t' do
        el = viewer.image(html: html_attributes)

        expect(el).to have_tag 'img', with: {
          'data-crop'     => 'fill',
          'data-format'   => file.format,
          'data-height'   => 100,
          'data-secure'   => true,
          'data-sign-url' => true,
          'data-version'  => file.version,
          'data-width'    => 200,
          alt:               'alt',
          height:            11,
          invalid:           'invalid',
          src:               'http://example.org',
          width:             22
        }
      end
    end
  end

  context 'when :html is blank' do
    let!(:html_attributes) { {} }

    context 'and :t is blank' do
      let!(:t_attributes) { {} }

      before { allow_any_instance_of(Attachy::File).to receive(:url).with(t_attributes) { 'http://example.org' } }

      it 'adds only the default transformation with file attributes' do
        el = viewer.image(t: t_attributes, html: html_attributes)

        expect(el).to have_tag 'img', with: {
          'data-format'   => file.format,
          'data-secure'   => true,
          'data-sign-url' => true,
          'data-version'  => file.version
        }
      end
    end

    context 'and :t is present' do
      let!(:t_attributes) { { height: 1, width: 2 } }

      before { allow_any_instance_of(Attachy::File).to receive(:url).with(t_attributes) { 'http://example.org' } }

      it 'adds the :t attributes on html attributes with default data' do
        el = viewer.image(t: t_attributes, html: html_attributes)

        expect(el).to have_tag 'img', with: {
          'data-format'   => file.format,
          'data-secure'   => true,
          'data-sign-url' => true,
          'data-version'  => file.version,
          height:            1,
          width:             2
        }
      end
    end
  end

  context 'when :html is not given' do
    context 'and :t is not given' do
      before { allow_any_instance_of(Attachy::File).to receive(:url).with(default_t) { 'http://example.org' } }

      it 'uses the default :html with default :t' do
        el = viewer.image

        expect(el).to have_tag 'img', with: {
          'data-crop'     => 'fill',
          'data-format'   => file.format,
          'data-height'   => 100,
          'data-secure'   => true,
          'data-sign-url' => true,
          'data-version'  => file.version,
          'data-width'    => 200,
          alt:               'image',
          height:            50,
          width:             150
        }
      end
    end

    context 'but :t is given' do
      let!(:t_attributes) { { height: 1, width: 2 } }

      before { allow_any_instance_of(Attachy::File).to receive(:url).with(t_attributes) { 'http://example.org' } }

      it 'uses the default :html with given :t overriding the default :t' do
        el = viewer.image(t: t_attributes)

        expect(el).to have_tag 'img', with: {
          'data-crop'     => 'fill',
          'data-format'   => file.format,
          'data-height'   => 1,
          'data-secure'   => true,
          'data-sign-url' => true,
          'data-version'  => file.version,
          'data-width'    => 2,
          alt:               'image',
          height:            50,
          width:             150
        }
      end
    end
  end

  context 'when given a :file' do
    let!(:file) { create :file, format: :png, version: 7 }

    it 'is used' do
      expect(file).to receive(:url).with(default_t) { 'http://example.org' }

      viewer.image(file)
    end
  end
end
