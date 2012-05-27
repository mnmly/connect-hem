
connect = require('connect')
hem     = require('./../src/connect-hem')
request = require('request')

describe "connect-hem", ->
  beforeEach ->
    @app = connect()
      .use(connect.logger("dev"))
      .use(connect.static("public"))
      .use(hem
        jsPath: '/js/main.js',
        slug: __dirname + "/support/slug.json"
      ).use((req, res) ->
        res.end "hello world\n"
      ).listen(3000)

  afterEach ->
    @app.close()

  it "should serve hello world, just to see", (done)->

    request 'http://localhost:3000', (error, response, body)->
      body.should.include('hello world')
      done()

  it "should serve compiled js", (done)->

    request 'http://localhost:3000/js/main.js', (error, response, body)->
      body.should.include('Init App')
      # Check if Spine is included
      body.should.include('Spine.Events')
      body.should.include('Spine.Module')
      body.should.include('Spine.Controller')
      done()
