ko = require 'knockout'
_ = require 'lodash'
api = require '../../api'
mdEditor = require '@tutor/markdown-editor'
m2e = require "@tutor/markdown2exercise"
moment = require 'moment'

class ViewModel
  constructor: ->
    @createNew = ko.observable(false)
    @resultJSON = ko.observable("")
    @showOverview = ko.computed => !@createNew()
    @exercises = ko.observableArray()
    @activationDate = ko.observable(moment().add(7, "days").toJSON())
    @dueDate = ko.observable(moment().add(14, "days").toJSON())
    @currentExercise = {}

    api.get.exercises().then (ex) =>
      @exercises(ex)

  newExercise: ->
    @currentExercise = {}
    @createNew(true)

  show: (data) ->
    @createNew(true)
    @init data.internals.source, data.activationDate, data.dueDate

  save: ->
    api.put.exercise @currentExercise
    @createNew(false)

  toDate: (json) ->
    moment(json).format("DD.MM.YYYY")

  fromNow: (json) ->
    moment(json).fromNow()

  discard: ->
    @createNew(false)

  updatePreview: (editor) ->
    exercise = (m2e editor.getValue())
    exercise.activationDate = @activationDate()
    exercise.dueDate = @dueDate()
    @currentExercise = exercise
    @resultJSON JSON.stringify exercise, null, 2

  initnew: ->
    @init "", moment().add(7,"days"), moment().add(14,"days")

  init: (value, activation, due) ->
    editor = mdEditor.create 'editor-new', value, plugins: [
      (editor) =>
        @updatePreview editor
    ]

    $("#activation-date").kalendae({
      selected: activation.format("MM/DD/YYYY")
      subscribe:
        change: (date) =>
          @activationDate date.toJSON()
          @updatePreview editor
      })
    $("#due-date").kalendae({
      selected: due.format("MM/DD/YYYY")
      subscribe:
        change: (date) =>
          @dueDate date.toJSON()
          @updatePreview editor
      })


fs = require 'fs'
module.exports = ->
  ko.components.register __filename.substr(__dirname.length, __filename.length - 7),
    template: fs.readFileSync __filename.substr(0, __filename.length - 7) + '.html', 'utf8'
    viewModel: ViewModel
  return __filename.substr(__dirname.length, __filename.length - 7)
