# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HexletCode::Tag do
  let(:service) { described_class }
  describe '.build' do
    context 'when valid tags' do
      it 'should build random tag with no attributes and value' do
        expect(service.build('br')).to eq('<br>')
        expect(service.build('div')).to eq('<div></div>')
      end

      it 'should build tag with attribute(s)' do
        expect(service.build('div', class: 'hello')).to eq('<div class="hello"></div>')
        expect(service.build('div', class: 'hello', id: 'my')).to eq('<div class="hello" id="my"></div>')
      end

      it 'should build tag with attribute(s) and value' do
        expect(service.build('div', class: 'p1') { 'Hello!' }).to eq('<div class="p1">Hello!</div>')
      end
    end

    context 'when invalid tags' do
      it 'not html tag' do
        expect(service.build('hello')).to eq(nil)
      end
    end
  end
end
