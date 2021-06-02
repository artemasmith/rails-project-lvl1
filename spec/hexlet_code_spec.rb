# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HexletCode do
  describe '#form_for' do
    it 'should return empty form' do
      expect(HexletCode.form_for).to eq("<form action=\"#\" method=\"post\">\n</form>")
    end
  end
end
