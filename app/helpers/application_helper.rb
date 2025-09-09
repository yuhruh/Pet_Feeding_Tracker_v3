module ApplicationHelper
  def locale_to_word_flag(locale)
    locales = {
      en: '🇺🇸 English',
      "zh-TW": '🇹🇼 繁體中文'
    }

    locales[locale.to_sym]
  end
end
