# frozen_string_literal: true

require 'mime/types'

module Attachy
  class Viewer
    def initialize(method, object, options = {}, view = ActionController::Base.helpers)
      @method  = method
      @object  = object
      @options = options
      @view    = view
    end

    def attachments
      [criteria].flatten.compact
    end

    def button_label_options
      { text: '...' }
    end

    def button_label(html: htm(:button))
      html = button_label_options.merge(html)

      @view.content_tag :span, html.delete(:text), html
    end

    def content(html: {})
      html = content_options.merge(html)

      return yield(html, attachments) if block_given?

      @view.content_tag :ul, nodes.join.html_safe, html
    end

    def content_options
      {
        class: :attachy__content,

        data: {
          crop:     metadata[:crop],
          height:   transform[:height],
          multiple: metadata[:multiple],
          width:    transform[:width]
        }
      }
    end

    def field_options
      { class: :attachy }
    end

    def field(html: {})
      html = field_options.merge(html)

      return yield(html) if block_given?

      @view.content_tag :div, content + file_button, html
    end

    def file_button_options
      { class: :attachy__button }
    end

    def file_button(html: htm(:button))
      html = file_button_options.merge(html)

      return yield(html) if block_given?

      @view.content_tag :div, button_label + file_field + hidden_field, html
    end

    def file_field_options
      options = { class: :attachy__fileupload }
      accept  = MIME::Types.type_for([metadata[:accept]].flatten.map(&:to_s))

      options[:accept]   = accept.join(',') if accept.present?
      options[:multiple] = true             if metadata[:multiple]

      options
    end

    def file_field(html: file_field_options)
      options = { html: html, tags: [ENV_TAG, TMP_TAG] }

      options[:folder] = metadata[:folder] if metadata[:folder]

      @view.cl_image_upload_tag @method, options
    end

    def hidden_field
      @view.hidden_field @object.class.name.downcase, @method, value: value, id: nil
    end

    def image(file = criteria, t: transform, html: htm)
      return if file.nil?

      url         = file.url(t)
      html        = html.reverse_merge(height: t[:height], width: t[:width])
      html[:data] = file.transform(t)

      @view.image_tag url, html
    end

    def link_options
      { class: :attachy__link }
    end

    def link(file = criteria, t: transform, tl: { crop: :none }, html: {})
      html = link_options.merge(data: tl).merge(html)

      return yield(html, attachments) if block_given?

      @view.link_to image(file, t: t), file.url(tl), html
    end

    def node_options
      { class: :attachy__node }
    end

    def node(file = criteria, tl: { crop: :none }, t: transform, html: {})
      html = html.reverse_merge(node_options)

      return yield(html, attachments) if block_given?

      value = [link(file, t: t, tl: tl)]
      value << remove_button unless @options[:destroy] == false

      @view.content_tag :li, value.join.html_safe, html
    end

    def nodes
      attachments.map { |file| node file }
    end

    def remove_button_options
      { class: :attachy__remove }
    end

    def remove_button(html: {})
      html = html.reverse_merge(remove_button_options)

      return yield(html) if block_given?

      @view.content_tag :span, '&#215;'.html_safe, html
    end

    def value
      default? ? '[]' : attachments.to_json
    end

    private

    def criteria
      @criteria ||= @object.send(@method)
    end

    def default?
      attachments.size == 1 && attachments.last.public_id == Attachy::File.default&.public_id
    end

    def htm(path = [])
      @options.dig(*[path, :html].flatten) || {}
    end

    def metadata
      @metadata ||= @object.send("#{@method}_metadata")
    end

    def transform(path = [])
      @options.dig(*[path, :t].flatten) || {}
    end
  end
end
