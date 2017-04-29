# frozen_string_literal: true

module Attachy
  module ViewHelper
    def attachy(method, object, options, block)
      viewer = Viewer.new(method, object, options, self)

      return block.call(viewer) if block

      viewer.field
    end

    def attachy_content(method, object, options = {})
      Viewer.new(method, object, options, self).content
    end

    def attachy_file_field(method, object, options = {})
      Viewer.new(method, object, options, self).file_field
    end

    def attachy_image(method, object, options = {})
      Viewer.new(method, object, options, self).image
    end

    def attachy_link(method, object, options = {})
      Viewer.new(method, object, options, self).link
    end

    def attachy_node(method, object, options = {})
      Viewer.new(method, object, options, self).node
    end
  end
end
