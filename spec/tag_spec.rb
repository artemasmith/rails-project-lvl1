# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HexletCode::Tag do
  let(:service) { described_class }
  describe '#build' do
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

  describe '#form_for' do
    let(:simle_form_result) { "<form action=\"#\" method=\"post\">\n</form>" }

    it { expect(service.form_for).to eq(simle_form_result) }

    User = Struct.new(:name, :job, keyword_init: true)
    describe '.input' do
      context 'when empty values input' do
        let(:obj) { User.new }
        it 'generates form with no values' do
          result = HexletCode.form_for obj do |f|
            f.input :name
          end
          expect(result).to eq("<form action=\"#\" method=\"post\">\n<label for=\"name\">Name</label>\n<input name=\"name\">\n</form>")
        end
      end

      let(:user) { User.new name: 'rob', job: 'hexlet' }
      let(:form_name_job_as) do
        "<form action=\"#\" method=\"post\">\n<label for=\"name\">Name</label>\n<input name=\"name\" value=\"rob\">\n<label for=\"job\">Job</label>\n<textarea name=\"job\" value=\"hexlet\"></textarea>\n</form>"
      end
      let(:form_job) do
        "<form action=\"#\" method=\"post\">\n<label for=\"job\">Job</label>\n<input name=\"job\" value=\"hexlet\">\n</form>"
      end

      it 'generate form with input filled' do
        result = HexletCode.form_for user do |f|
          f.input :job
        end
        expect(result).to eq(form_job)
      end

      it 'generate form with input filled' do
        result = HexletCode.form_for user do |f|
          f.input :name
          f.input :job, as: :text
        end
        expect(result).to eq(form_name_job_as)
      end
    end

    describe '#submit' do
      let(:user) { User.new name: 'rob', job: 'hexlet' }
      let(:options) { { value: 'temp', name: 'sub' } }
      let(:submit_form) do
        "<form action=\"#\" method=\"post\">\n<input name=\"sub\" type=\"submit\" value=\"temp\">\n</form>"
      end

      it 'generate form with submit' do
        result = HexletCode.form_for user do |f|
          f.submit(options)
        end

        expect(result).to eq(submit_form)
      end
    end
  end
end
