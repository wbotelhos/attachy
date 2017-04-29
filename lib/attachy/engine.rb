# frozen_string_literal: true

require 'attachy/builders/attachy/form_builder'
require 'attachy/helpers/attachy/view_helper'

module Attachy
  module Rails
    class Engine < ::Rails::Engine
      initializer 'attachy.include_view_helper' do |_app|
        ActiveSupport.on_load :action_view do
          include ViewHelper

          ActionView::Helpers::FormBuilder.include FormBuilder
        end
      end
    end
  end
end
