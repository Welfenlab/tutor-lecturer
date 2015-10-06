ko = require 'knockout'
_ = require 'lodash'
api = require '../../api'
mdEditor = require '@tutor/markdown-editor'
m2e = require "@tutor/markdown2exercise"

class ViewModel
  constructor: ->
    @createNew = ko.observable(false)
    @resultJSON = ko.observable("")
    @showOverview = ko.computed => !@createNew()
    @exercises = ko.observableArray()

  newExercise: ->
    @createNew(true)

  show: ->


  save: ->
    @createNew(false)

  discard: ->
    @createNew(false)

  initnew: ->
    editor = mdEditor.create 'editor-new', '', plugins: [
      (editor) =>
        @resultJSON JSON.stringify (m2e editor.getValue()), null, 2
    ]


fs = require 'fs'
module.exports = ->
  ko.components.register __filename.substr(__dirname.length, __filename.length - 7),
    template: fs.readFileSync __filename.substr(0, __filename.length - 7) + '.html', 'utf8'
    viewModel: ViewModel
  return __filename.substr(__dirname.length, __filename.length - 7)
