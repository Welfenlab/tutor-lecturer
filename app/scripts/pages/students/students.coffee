ko = require 'knockout'
_ = require 'lodash'
api = require '../../api'

class StudentViewModel
  constructor: (data) ->
    @id = data.id
    @shortId = ko.computed => @id.substring(0, 6)
    @matrikel = data.matrikel
    @name = data.name
    @pseudonym = data.pseudonym
    @solutions = ko.observableArray()

  load: ->
    api.solutions.getOfStudent(@id).then (solutions) ->
      @solutions solutions

class ViewModel
  constructor: ->
    @selectedStudent = ko.observable null
    @studentSelected = ko.computed => @selectedStudent() isnt null
    @searchInput = ko.observable ''

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
    student.load()

fs = require 'fs'
module.exports = ->
  ko.components.register __filename.substr(__dirname.length, __filename.length - 7),
    template: fs.readFileSync __filename.substr(0, __filename.length - 7) + '.html', 'utf8'
    viewModel: ViewModel
  return __filename.substr(__dirname.length, __filename.length - 7)
