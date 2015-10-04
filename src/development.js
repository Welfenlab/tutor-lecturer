var express = require("express");

// initialize the development environment
module.exports = function(config){
  var configureServer = function(API, DB){
    config.modules = []

    config.modules.push(function(app, config){
      app.use(express.static('./build'));
      // enable cors for development (REST API over Swagger)
      app.use(function(req, res, next) {
        res.header("Access-Control-Allow-Origin", "*");
        res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
        next();
      });
      app.use(require('morgan')('dev'));
    });
  };

  if(!config.devrdb){
    console.log("### development environment ###");
    var MemDB = require("@tutor/memory-database")(config);
    restAPI = require("./rest")(MemDB);
    return new Promise(function(resolve){
      configureServer(restAPI, MemDB);
      resolve(restAPI);
    });
  } else {
    console.log("### development environment with RethinkDB @" +
      config.database.host + ":" + config.database.port + "/" + config.database.name + " ###")
    var rethinkDB = require("@tutor/rethinkdb-database")(config);
    return rethinkDB.then(function(DB){
      restAPI = require("./rest")(DB);
      configureServer(restAPI, DB);
      return restAPI;
    });
  }
}
