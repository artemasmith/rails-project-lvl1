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

      def form_for(obj = {}, **attrs, &block)
        new.form_for(obj, **attrs, &block)
      end
    end

    def build(tag, obj = {})
      return unless ALL_TAGS.include?(tag)

      if paired?(tag)
        "<#{tag}#{parsed_attributes(obj)}>#{yield(self) if block_given?}</#{tag}>"
      else
        "<#{tag}#{parsed_attributes(obj)}>"
      end
    end

    def form_for(obj = {}, **attrs)
      url = attrs[:url] || attrs['url'] || '#'
      method = attrs[:method] || attrs['method'] || 'post'
      build('form', action: url, method: method) do
        @obj = obj
        @accumulator = "\n"
        yield(self) if defined?(yield)
        @accumulator
      end
    end

    # rubocop:disable Naming/MethodParameterName, Metrics/MethodLength
    def input(name, as: nil, **attrs)
      prepend_tag = ''
      append_tag = ''
      additional = ''
      if as
        prepend_tag = convert_as_to_tag(as)
        append_tag = "</#{convert_as_to_tag(as)}>"
      else
        prepend_tag = 'input'
      end

      if !attrs.nil? && attrs != {}
        additional = " " + attrs.sort.map {|k,v| "#{k}=\"#{v}\"" }.join(" ")
      end

      value = " value=\"#{@obj.public_send(name)}\"" if @obj && !@obj.public_send(name).nil?
      @accumulator += "#{label(name)}\n"
      @accumulator += "<#{prepend_tag} name=\"#{name}\"#{value}#{additional}>#{append_tag}\n"
    end

    # rubocop:enable Naming/MethodParameterName, Metrics/MethodLength
    def label(for_tag)
      build('label', for: for_tag.to_s) { for_tag.capitalize }
    end

    def submit(value = '', **attrs)
      options = {}
      options[:value] ||= value|| 'Save'
      options[:name] ||= attrs[:name] || attrs['name'] || 'commit'
      @accumulator += "#{build('input', options.merge(type: 'submit').sort)}\n"
    end

    private

    def value_by_name(name)
      return @obj[name] if @obj.is_a? Hash

      @obj.public_send(name)
    end

    def convert_as_to_tag(sent_as)
      case sent_as
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
