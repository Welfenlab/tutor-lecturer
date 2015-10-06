ko = require 'knockout'
_ = require 'lodash'
api = require '../../api'

class ViewModel
  constructor: ->

  init: ->
    api.post.init()

  empty: ->
    api.post.empty()

fs = require 'fs'
module.exports = ->
  ko.components.register __filename.substr(__dirname.length, __filename.length - 7),
    template: fs.readFileSync __filename.substr(0, __filename.length - 7) + '.html', 'utf8'
    viewModel: ViewModel
  return __filename.substr(__dirname.length, __filename.length - 7)