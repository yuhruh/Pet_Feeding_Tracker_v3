module ApplicationHelper
  def locale_to_word_flag(locale)
    locales = {
      en: '🇺🇸 English',
      "zh-TW": '🇹🇼 繁體中文',
      "ja": '🇯🇵 日本語'
    }

    locales[locale.to_sym]
  end
end
