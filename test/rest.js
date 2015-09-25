
chai = require("chai");
chai.should();

var config = require("cson").load("./test/fixtures/config.cson");
var request = require("request");
var TutorServer = require("@tutor/server");


var memDB = require("@tutor/memory-database")();
var restoreDB = function(){
  memDB.Restore("./test/fixtures/db.json");
};
var restAPI = require("../src/rest")(memDB);
config.modules = [function(app,config){
  app.use(function(req,res,next){ req.session = {uid:"tutor"}; next() });
}];
config.log = {error:function(){},log:function(){}};
var server = TutorServer(config);

// register rest API
restAPI.forEach(function(rest){
  server.createRestCall(rest);
});
server.start()
var doSimpleRequest = function(method, path, data, fn){
  request({
    url: "http://"+config.domainname+":"+config.developmentPort+"/api"+path,
    method: method, //Specify the method
    form: data,
    headers: { //We can define headers too
        'Content-Type': 'MyContentType',
        'Custom-Header': 'Custom Value'
    }
  }, fn);
}
var doRequest = function(method,path,data,fn){
  if(typeof(data) == "function"){
    fn = data;
    data = null;
  }
  doSimpleRequest(method,path,data,function(err,res,body){
    var parsed = null;
    try{
      parsed = JSON.parse(body);
      fn(err,res,parsed);
    } catch(e){
      console.log("Error parsing body\n"+body);
      console.log(e);
      fn(e);
    }
  });
}

beforeEach(function(){
  restoreDB();
})

describe("Student REST API", function(){
  it("should return all exercises",function(done){
    doRequest("GET","/exercises",
      function(err, res, body){
        (err == null).should.be.true;
        body.should.have.length(2);
        res.statusCode.should.equal(200);
        done();
      });
  });

  it("a single exercise should contain tasks", function(done){
    doRequest("GET", "/exercises/ee256059-9d92-4774-9db2-456378e04586",
      function(err, res, body){
        (err == null).should.be.true;
        body.tasks.forEach(function(t){
          (typeof(t)).should.equal("object");
        });
        res.statusCode.should.equal(200);
        done();
    });
  });

  it("should be possible to get all tutors", function(done){
    doRequest("GET", "/tutors",
      function(err, res, body){
        (err == null).should.be.true;
        res.statusCode.should.equal(200);
        body.should.have.length(1);
        done();
    });
  });

  it("should be possible to create a new tutor", function(done){
    doSimpleRequest("PUT", "/tutors", {tutor:{name:"NewTutor", pw:"blubb"}},
      function(err, res, body){
        (err == null).should.be.true;
        res.statusCode.should.equal(204);
        done();
    });
  });

  it("should list all groups", function(done){
    doRequest("GET", "/groups",
      function(err, res, body){
        (err == null).should.be.true;
        res.statusCode.should.equal(200);
        body.should.have.length(2);
        done();
    });
  });

  it("should list all users", function(done){
    doRequest("GET", "/users",
      function(err, res, body){
        (err == null).should.be.true;
        res.statusCode.should.equal(200);
        body.should.have.length(3);
        done();
    });
  });

});
