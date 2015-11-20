ko = require 'knockout'
_ = require 'lodash'
api = require '../../api'

class ViewModel
  constructor: ->
    @selectedStudent = ko.observable null
    @studentSelected = ko.computed => @selectedStudent() isnt null
    @searchInput = ko.observable ''

    @students = ko.observableArray()
    api.students.getAll()
    .then (students) => @students students

    @displayedStudents = ko.computed () =>
      if @searchInput().trim() is ''
        @students()
      else
        _.filter @students(), (student) => ('' + student.matrikel).indexOf(@searchInput()) is 0

fs = require 'fs'
module.exports = ->
  ko.components.register __filename.substr(__dirname.length, __filename.length - 7),
    template: fs.readFileSync __filename.substr(0, __filename.length - 7) + '.html', 'utf8'
    viewModel: ViewModel
  return __filename.substr(__dirname.length, __filename.length - 7)
