# frozen_string_literal: true

class User < ::ActiveRecord::Base
  has_attachment :avatar, accept: %i[jpg png]

  has_attachments :photos, accept: %i[jpg png], maximum: 10
end
