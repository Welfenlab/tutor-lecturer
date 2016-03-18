ko = require 'knockout'
_ = require 'lodash'
api = require '../../api'

class SolutionViewModel
  constructor: (data) ->
    @id = data.id
    @points = _.sum data.result.points
    @maximumPoints = ko.observable 0
    @title = ko.observable 'Loading...'

    api.get.exercise(data.exercise).then (exercise) =>
      @maximumPoints _.sum exercise.tasks, 'maxPoints'
      @title exercise.title

class StudentViewModel
  constructor: (data) ->
    @id = data.id
    @shortId = ko.computed => @id.substring(0, 6)
    @matrikel = data.matrikel
    @name = data.name
    @pseudonym = data.pseudonym
    @solutions = ko.observable([])

    @totalPoints = ko.observable data.totalPoints
    @maximumPoints = ko.computed => _.sum @solutions(), (s) -> s.maximumPoints()
    @pointsPercentage = ko.computed =>
      if @maximumPoints() > 0
        (@totalPoints() / @maximumPoints() * 100).toFixed(1)
      else
        0

    api.solutions.getOfStudent(@id).then (solutions) =>
      @solutions solutions.map((s) -> new SolutionViewModel(s))

class ViewModel
  constructor: ->
    @selectedStudent = ko.observable null
    @studentSelected = ko.computed => @selectedStudent() isnt null
    @searchInput = ko.observable ''
    @config = api.get.config()

    @students = ko.observableArray()
    api.students.getAll()
    .then (students) => @students students.map((s) -> new StudentViewModel(s))

    @displayedStudents = ko.computed () =>
      if @searchInput().trim() is ''
        @students()
      else
        _.filter @students(), (student) => ('' + student.matrikel).indexOf(@searchInput()) is 0

  showStudent: (student) ->
    @selectedStudent(student)

  editSolution: (solution) ->
    @config.then (config) =>
      window.open("#{config.correctorUrl}/correction/by-solution/#{solution.id}", '_blank')

  regeneratePdf: (solution) ->
    @config.then (config) =>
      $.get("#{config.slaveUrl}/pdfs/process/#{solution.id}")
      .done -> alert 'PDF will be regenerated'
      .fail -> alert 'Regenerating the PDF failed'

fs = require 'fs'
module.exports = ->
  ko.components.register __filename.substr(__dirname.length, __filename.length - 7),
    template: fs.readFileSync __filename.substr(0, __filename.length - 7) + '.html', 'utf8'
    viewModel: ViewModel
  return __filename.substr(__dirname.length, __filename.length - 7)
