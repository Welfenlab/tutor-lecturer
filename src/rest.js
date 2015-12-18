
var bcrypt = require('bcrypt-then');
var _ = require('lodash');
var request = require('request');

module.exports = function(DB, config){
  config.slave = config.slave || {}
  if(process.env.SLAVE_PORT){
    config.slave.port = process.env.SLAVE_PORT
  }
  if(process.env.SLAVE_HOST){
    config.slave.host = process.env.SLAVE_HOST
  }
  
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
    }, apiMethod: "postByBodyParam", param: "tutor", errStatus: 400 },

    { path: '/api/groups', dataCall: DB.Manage.listGroups, apiMethod: "get" },

    { path: '/api/students', dataCall: DB.Manage.listUsers, apiMethod: "get"},

    { path: '/api/students/:studentId/solutions', dataCall: DB.Manage.getStudentsSolutions, apiMethod: 'getByParam', param: 'studentId', errStatus: 400},

    { path: '/api/solutions/', dataCall: DB.Manage.querySolutions, apiMethod: 'getByQuery', param: 'search', errStatus: 400},
    
    { path: '/api/slave/sync/solution/:id', dataCall: function(id) {
      return new Promise(function(resolve, reject) {
        request('http://' + config.slave.host + ':' + config.slave.port + '/solution/store/' + id, function(err, response, body){
           if(err){
             reject(err)
           }
           resolve()
        })
      });
    }, apiMethod: "postByBodyParam" },
    
    { path: '/api/slave/pfd/for/solution/:id', dataCall: function(id) {
      return new Promise(function(resolve, reject) {
        request('http://' + config.slave.host + ':' + config.slave.port + '/pdf/process/' + id, function(err, response, body){
           if(err){
             reject(err)
           }
           resolve()
        })
      });
    }, apiMethod: "postByBodyParam" },
    
    { path: '/api/config', dataCall: function(){
      return Promise.resolve(config)
    }, apiMethod: 'get' }
  ];
};
