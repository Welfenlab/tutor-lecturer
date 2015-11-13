ko = require 'knockout'
require 'knockout-mapping'
#not_found = './pages/not_found'
i18n = require 'i18next-ko'
Router = require './router'

ko.components.register 'page-not-found', template: "<h2>Page not found</h2>"

class ViewModel
  constructor: ->
    @router = new Router()
    @isActive = (path) => ko.computed => @router.path().indexOf(path) == 0

  load: ->
    @router.goto location.hash.substr(1)

i18n.init {
  en:
    translation: require '../i18n/en'
  }, 'en', ko

module.exports = new ViewModel()
