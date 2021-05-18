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
    class << self
      def build(tag, attrs = {}, &block)
        return unless ALL_TAGS.include?(tag)

        if paired?(tag)
          "<#{tag}#{parsed_attributes(attrs)}>#{block.call if block_given?}</#{tag}>"
        else
          "<#{tag}#{parsed_attributes(attrs)}>"
        end
      end

      private

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
end
