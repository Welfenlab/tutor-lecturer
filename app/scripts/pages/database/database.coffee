ko = require 'knockout'
_ = require 'lodash'
api = require '../../api'

class ViewModel
  constructor: ->
    @allow = ko.observable no

  init: ->
    if @allow()
      api.database.initialize().then -> alert 'Database initialized.'

  empty: ->
    if @allow()
      api.database.clear().then -> alert 'Database cleared.'

fs = require 'fs'
module.exports = ->
  ko.components.register __filename.substr(__dirname.length, __filename.length - 7),
    template: fs.readFileSync __filename.substr(0, __filename.length - 7) + '.html', 'utf8'
    viewModel: ViewModel
  return __filename.substr(__dirname.length, __filename.length - 7)
