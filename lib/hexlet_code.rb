# frozen_string_literal: true

require_relative 'hexlet_code/version'
require_relative 'hexlet_code/tag'

module HexletCode
  def self.form_for(obj = {}, **attrs, &block)
    Tag.form_for(obj, **attrs, &block)
  end
end
