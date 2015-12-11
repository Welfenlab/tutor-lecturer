ko = require 'knockout'
_ = require 'lodash'
api = require '../../api'
mdEditor = require '@tutor/markdown-editor'
m2e = require "@tutor/markdown2exercise"
moment = require 'moment'
require '@tutor/task-preview'

class Exercise
  constructor: (data) ->
    if data
      @id = ko.observable data.id
      @activationDate = ko.observable data.activationDate
      @dueDate = ko.observable data.dueDate
      @source = ko.observable data.internals.source
    else
      @id = ko.observable('')
      @activationDate = ko.observable moment().add(7, 'days').toDate()
      @dueDate = ko.observable moment().add(14, 'days').toDate()
      @source = ko.observable ''

    @json = ko.computed =>
        exercise = m2e @source()
        exercise.activationDate = @activationDate()
        exercise.dueDate = @dueDate()
        exercise.id = @id()
        return exercise

class ViewModel
  constructor: ->
    @createNew = ko.observable(false)
    @showOverview = ko.computed => !@createNew()
    @exercises = ko.observableArray()
    @currentExercise = ko.observable new Exercise()
    @exerciseData = ko.computed => @currentExercise().json()
    @resultJSON = ko.computed => JSON.stringify @exerciseData(), null, 2
    @warnings = ko.computed => m2e.check @currentExercise().source()

    @currentExercise.subscribe =>
        editor = mdEditor.create 'editor-new', @currentExercise().source(), plugins: [
          _.throttle ((editor) =>
            @updatePreview editor), 1000
        ]

        $("#activation-date").kalendae({
          selected: moment(@currentExercise().activationDate()).format("MM/DD/YYYY")
          subscribe:
            change: (date) =>
              @currentExercise().activationDate date
              @updatePreview editor
          })
        $("#due-date").kalendae({
          selected: moment(@currentExercise().dueDate()).format("MM/DD/YYYY")
          subscribe:
            change: (date) =>
              @currentExercise().dueDate date
              @updatePreview editor
          })

    @reload()

  reload: ->
    api.get.exercises().then (ex) =>
      @exercises(ex.sort((a, b) -> parseInt(a.number) - parseInt(b.number)))

  newExercise: ->
    @createNew(true)
    @currentExercise new Exercise()

  show: (data) ->
    @createNew(true)
    @currentExercise new Exercise(data)

  save: ->
    api.put.exercise @currentExercise().json()
    @reload()
    @createNew(false)

  toDate: (json) ->
    moment(json).format("DD.MM.YYYY")

  fromNow: (json) ->
    moment(json).fromNow()

  discard: ->
    @reload()
    @createNew(false)

  updatePreview: (editor) ->
    @currentExercise().source editor.getValue()

  previewify: (task) ->
    previewTask = ko.mapping.fromJS(task)
    previewTask.modelSolution = previewTask.solution
    previewTask.solution = previewTask.prefilled
    return previewTask

fs = require 'fs'
module.exports = ->
  ko.components.register __filename.substr(__dirname.length, __filename.length - 7),
    template: fs.readFileSync __filename.substr(0, __filename.length - 7) + '.html', 'utf8'
    viewModel: ViewModel
  return __filename.substr(__dirname.length, __filename.length - 7)
