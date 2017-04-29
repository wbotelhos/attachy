# frozen_string_literal: true

module Attachy
  module FormBuilder
    def attachy(method, options = {}, &block)
      @template.attachy method, object, options, block
    end

    def attachy_content(method, options = {}, &block)
      @template.attachy_content method, object, options, block
    end

    def attachy_file_field(method, options = {})
      @template.attachy_file_field method, object, options
    end
  end
end
