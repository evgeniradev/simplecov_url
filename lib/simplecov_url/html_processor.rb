# frozen_string_literal: true

require 'simplecov_url/access_manager'

module SimplecovUrl
  class HtmlProcessor
    HTML_FILE         = 'index.html'
    CSS_FILE          = 'application.css'
    JAVASCRIPT_FILE   = 'application.js'

    def self.call
      new.html
    end

    def html
      return if AccessManager.deny?

      tmp = read_file(HTML_FILE)

      return no_report_message unless tmp

      tmp = remove_link_and_script_tags(tmp)

      tmp = img_href_tags_to_base64(tmp)

      return frontend_error(CSS_FILE) unless css

      return frontend_error(JAVASCRIPT_FILE) unless javascript

      tmp = insert_css_and_javascript_as_inline(tmp)

      tmp.html_safe
    rescue StandardError => e
      general_error(e)
    end

    private

    def files
      @files ||= Dir.glob(File.join(Rails.root, 'coverage', '**', '*'))
    end

    def read_file(name)
      file = files.find { |f| f.include?(name) }

      file ? File.read(file) : nil
    end

    def javascript
      @javascript ||= begin
        tmp = read_file(JAVASCRIPT_FILE)

        return nil unless tmp

        "<script>#{tmp}</script>"
      end
    end

    def css
      @css ||= begin
        tmp = read_file(CSS_FILE)

        return nil unless tmp

        tmp = background_url_attributes_to_base64(tmp)

        "<style>#{tmp}</style>"
      end
    end

    def background_url_attributes_to_base64(content)
      imgs_to_base64(
        content,
        attribute_regex: /url\(.*?\)/,
        paths_regex: /(url\W*)|(\W*$)/,
        replacement: lambda do |encoded_img, mime_type|
          "url(data:#{mime_type};base64,#{encoded_img})"
        end
      )
    end

    def img_href_tags_to_base64(content)
      imgs_to_base64(
        content,
        attribute_regex: /<img src=['|"].*?['|"]/,
        paths_regex: /<img.*\.\/|\W*$/,
        replacement: lambda do |encoded_img, mime_type|
          "<img src='data:#{mime_type};base64,#{encoded_img}'"
        end
      )
    end

    def imgs_to_base64(content, attribute_regex:, paths_regex:, replacement:)
      attributes = content.scan(attribute_regex).flatten

      img_paths = attributes.map do |attribute|
        [attribute, attribute.gsub(paths_regex, '')]
      end

      base64s = img_paths.map do |attribute, img_path|
        file = files.find { |f| f.include?(img_path) }

        mime_type = "image/#{File.extname(file).delete('.')}"

        encoded_img = Base64.strict_encode64(File.read(file))

        [attribute, replacement.call(encoded_img, mime_type)]
      end.to_h

      base64s.each do |attribute, base64|
        content = content.gsub(attribute, base64)
      end

      content
    end

    def insert_css_and_javascript_as_inline(tmp)
      position = (tmp =~ /<\/head>/)

      tmp.insert(position, css)
      tmp.insert(position, javascript)
    end

    def remove_link_and_script_tags(tmp)
      tmp.gsub(/<link.*>/, '').gsub(/<script.*<\/script>/, '')
    end

    def no_report_message
      'No test coverage report available.'
    end

    def frontend_error(filename)
      "Error: '#{filename}' file is missing."
    end

    def general_error(error)
      puts(error.message)
      puts(error.backtrace)
      'Error: Unable to load test coverage report.'
    end
  end
end
