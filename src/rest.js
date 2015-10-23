
var bcrypt = require('bcrypt-then');
var _ = require('lodash');

module.exports = function(DB){
  return [
    { path: '/api/db/init', dataCall: DB.Utils.Init, apiMethod: "post" },
    { path: '/api/db/empty', dataCall: DB.Utils.Empty, apiMethod: "post" },

    { path: '/api/exercises', dataCall: DB.Manage.get, apiMethod: "get" },
    { path: '/api/exercises/:id', dataCall: DB.Manage.getById, apiMethod: "getByParam", param: "id" },
    { path: '/api/exercises', dataCall: DB.Manage.storeExercise, apiMethod: "putByBodyParam", param: "exercise" },

    { path: '/api/tutors', dataCall: DB.Manage.listTutors, apiMethod: "get"},
    { path: '/api/tutors', dataCall: function(tutor){
      // first generate some salt and create a password hash ;)
      // the salt is stored in the hash
      return bcrypt.hash(tutor.password, 10).then(
        function(pw){
          tutor.password = pw;
          return DB.Manage.storeTutor(tutor)
        }
      );
    }, apiMethod: "postByBodyParam", param: "tutor"},

    { path: '/api/groups', dataCall: DB.Manage.listGroups, apiMethod: "get" },

    { path: '/api/users', dataCall: DB.Manage.listUsers, apiMethod: "get"},

  ];
};
