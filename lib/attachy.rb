# frozen_string_literal: true

module Attachy
  ENV_TAG = "attachy_#{Rails.env}"
  TMP_TAG = :attachy_tmp
end

require 'cloudinary'

require 'attachy/engine'
require 'attachy/models/attachy/extension'
require 'attachy/models/attachy/file'
require 'attachy/models/attachy/viewer'

ActiveRecord::Base.include Attachy::Extension
