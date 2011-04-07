include Globalize
Locale.set_base_language 'fr-FR'
LOCALES = {'en' => 'en-US',
           'fr' => 'fr-FR'}.freeze
           
 module Globalize # :nodoc:
  class DbViewTranslator
    alias_method :orig_fetch_view_translation, :fetch_view_translation
    def fetch_view_translation(key, language, idx, namespace = nil)
      ActiveRecord::Base.silence do
        orig_fetch_view_translation(key, language, idx, namespace = nil)
      end
    end
  end
 end