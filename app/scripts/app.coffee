ko = require 'knockout'
require 'knockout-mapping'
#not_found = './pages/not_found'
i18n = require 'i18next-ko'
Router = require './router'

ko.components.register 'page-not-found', template: "<h2>Page not found</h2>"

viewModel =
  availableLanguages: ['en']
  language: ko.observable 'en'

  router: new Router()

i18n.init {
  en:
    translation: require '../i18n/en'
  }, 'en', ko
viewModel.language.subscribe (v) -> i18n.setLanguage v

module.exports = viewModel
