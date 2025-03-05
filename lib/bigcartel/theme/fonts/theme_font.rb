require 'yaml'

class ThemeFont < Struct.new(:name, :family, :weights, :collection)
  class << self
    def all
      @@all ||= Array.new.tap { |fonts|
        source.each_pair { |collection, collection_fonts|
          collection_fonts.values.each { |font|
            fonts << ThemeFont.new(font['name'], font['family'], font['weights'], collection)
          }
        }
      }.sort_by { |font| font.name }
    end

    def options
      @@options ||= all.map(&:name)
    end

    def find_by_name(name)
      all.find { |font|
        name.downcase == font.name.downcase
      }
    end

    def find_family_by_name(name)
      if font = find_by_name(name)
        font.family
      else
        name
      end
    end

    def google_fonts
      @@google_fonts ||= all.select { |font|
        font.collection == 'google'
      }
    end

    def google_font_names
      google_fonts.map(&:name)
    end

    def google_font_url_for_fonts(fonts)
      fonts = fonts.map do |font|
        if font.kind_of? ThemeFont
          font.weights ? "#{font.name}:#{font.weights}" : font.name
        else
          font
        end
      end

      "//fonts.googleapis.com/css?family=#{ fonts.uniq.map { |font| font.gsub(' ', '+') }.join('|') }&display=swap"
    end

    def google_font_url_for_all_fonts
      google_font_url_for_fonts(google_fonts)
    end

    def google_font_url_for_theme(fonts, settings)
      google_fonts = fonts.keys.map { |key| settings[key] }.compact.
        map { |font_name| find_by_name font_name }.
        compact.
        select { |font| font.collection == 'google' }.
        sort_by { |font| font.name }

      google_fonts.empty? ? nil : google_font_url_for_fonts(google_fonts)
    end

    def google_font_url_for_theme_array(fonts, settings, options = {})
      defaults = {
        include_protocol: false,
        include_weights: true
      }
      opts = defaults.merge(options)

      google_fonts = fonts.keys.map { |key| settings[key] }.compact
        .map { |font_name| find_by_name(font_name) }
        .compact
        .select { |font| font.collection == 'google' }
        .sort_by { |font| font.name }

      return [] if google_fonts.empty?

      base_url = opts[:include_protocol] ? "https://fonts.googleapis.com/css?family=" : "//fonts.googleapis.com/css?family="

      google_fonts.map do |font|
        font_string = if opts[:include_weights] && font.weights
                        "#{font.name}:#{font.weights}"
                      else
                        font.name
                      end
        "#{base_url}#{font_string.gsub(' ', '+')}&display=swap"
      end
    end

    private

    def source
      @@source ||= YAML.load(File.read(File.join(File.dirname(__FILE__), 'theme_fonts.yml')))
    end
  end
end
