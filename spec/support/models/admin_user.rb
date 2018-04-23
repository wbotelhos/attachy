# frozen_string_literal: true

class AdminUser < ::ActiveRecord::Base
  has_attachment :avatar, accept: %i[jpg png]
end
