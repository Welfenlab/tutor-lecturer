ko = require 'knockout'
_ = require 'lodash'
api = require '../../api'

class TutorViewModel
  constructor: (data) ->
    @name = ko.observable data.name
    @contingent = ko.observable data.contingent

class ViewModel
  constructor: ->
    @newUsername = ko.observable()
    @newPassword = ko.observable()
    @newContingent = ko.observable()
    @creating = ko.observable no
    @canCreate = ko.computed =>
      @newUsername() and @newUsername().trim() != '' and
      @newPassword() and @newPassword().trim() != '' and
      @newContingent()

    @tutors = ko.observableArray()
    api.tutors.getAll()
    .then (tutors) => @tutors tutors.map (t) -> new TutorViewModel(t)
    .catch -> alert 'Loading tutors failed'

  createTutor: ->
    @creating yes
    api.tutors.create
      name: @newUsername()
      password: @newPassword()
      contingent: parseInt @newContingent()
    .then =>
      @creating no
      existing = _.find @tutors(), (t) => t.name() == @newUsername()
      if existing
        existing.contingent parseInt @newContingent()
      else
        @tutors.push new TutorViewModel(name: @newUsername(), contingent: parseInt @newContingent())
      @newUsername ''
      @newPassword ''
      @newContingent null
    .catch =>
      @creating no
      alert 'Creating the tutor failed.'

fs = require 'fs'
module.exports = ->
  ko.components.register __filename.substr(__dirname.length, __filename.length - 7),
    template: fs.readFileSync __filename.substr(0, __filename.length - 7) + '.html', 'utf8'
    viewModel: ViewModel
  return __filename.substr(__dirname.length, __filename.length - 7)
