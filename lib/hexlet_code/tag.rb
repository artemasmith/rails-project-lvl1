# frozen_string_literal: true

module HexletCode
  class Tag
    PAIR_TAGS = %w[html head body title p h1 h2 h3 h4 h5 h6 a img pre blockquote i b tt em
                   strong cite ol ul li dl dt dd table tr td thead tbody label title style header footer
                   main nav section code data dfn mark kbd q rb rp rt rtc ruby s samp span small strong sub time var
                   wbr area audio map track video embed iframe object param picture portal source script noscript
                   canvas del ins caption col colgroup tfoot th form legend meter div].freeze
    UNPAIRED_TAGS = %w[input br hr meta img].freeze
    ALL_TAGS = PAIR_TAGS + UNPAIRED_TAGS

    # EntryPoint
    class << self
      def build(tag, obj = {}, &block)
        new.build(tag, obj, &block)
      end
      
      def form_for(obj = {}, &block)
        new.form_for(obj, &block)
      end
    end

    def build(tag, obj = {}, &block)
      @tag = tag
      @obj = obj
      return unless ALL_TAGS.include?(tag)

      if paired?(tag)
        "<#{tag}#{parsed_attributes(obj)}>#{yield(self) if block_given?}</#{tag}>"
      else
        "<#{tag}#{parsed_attributes(obj)}>"
      end
    end

    def form_for(obj = {}, &block)
      build('form', action: '#', method: 'post') do
        @obj = obj
        @accumulator = ""
        result = ""
        yield(self) if defined?(yield)
        @accumulator
      end
    end

    def input(name, as: nil)
      prepend_tag = ''
      append_tag = ''
      if as
        prepend_tag = convert_as_to_tag(as)
        append_tag = "</#{convert_as_to_tag(as)}>"
      else
        prepend_tag = "input"
      end

      value = " value=\"#{@obj.public_send(name)}\"" if (@obj && @obj.public_send(name))

      @accumulator += "<#{prepend_tag} name=\"#{name}\"#{value}>#{append_tag}"
    end

    private

    def convert_as_to_tag(as)
      case as
      when :text
        'textarea'
      end
    end

    # rubocop:disable Style/StringConcatenation
    def parsed_attributes(attrs)
      return '' if attrs.empty?

      ' ' + attrs.sort.map { |k, v| "#{k}=\"#{v}\"" }.join(' ')
    end
    # rubocop:enable Style/StringConcatenation

    def paired?(tag)
      PAIR_TAGS.include?(tag)
    end
  end
end
