# frozen_string_literal: true

require_relative 'hexlet_code/version'
require_relative 'hexlet_code/tag'

module HexletCode
  def self.form_for
    Tag.build('form', action: '#', method: 'post')
  end
end
