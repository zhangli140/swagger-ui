fs          = require 'fs'
{exec}      = require 'child_process'
util        = require 'util'
request     = require 'request'
handlebars  = require 'handlebars'

task 'spec', "Run the test suite", ->
  exec "open spec.html", (err, stdout, stderr) ->
    throw err if err

task 'watch', 'Watch source files for changes and autocompile', ->
  notify "Watching source files for changes..."
  
  fs.watchFile "src/swagger-ui.coffee", (curr, prev) ->
    if +curr.mtime isnt +prev.mtime
      invoke 'bake'
      
  fs.watchFile "src/swagger-ui-spec.coffee", (curr, prev) ->
    if +curr.mtime isnt +prev.mtime
      invoke 'bake_spec'
    
task 'bake', 'Compile everything into swagger-ui.js', ->
  # Transpile the spec
  invoke 'bake_spec'

  # Transpile swagger-ui.coffee
  exec "coffee --compile --output lib/grounds/ src/swagger-ui.coffee", (err, stdout, stderr) ->
    throw err if err
    
    # Precompile the Handlebars template
    exec "handlebars src/template.html -f lib/grounds/template.js", (err, stdout, stderr) ->
      throw err if err
    
      # Join all the js files into one
      exec "cat lib/grounds/*.js > lib/swagger-ui.js", (err, stdout, stderr) ->
      throw err if err
      
      notify 'lib/swagger-ui.js is ready'

# This is separate from the regular bake task for faster compilation during development
task 'bake_spec', 'Compile spec from coffee to js', ->
  exec "coffee --compile --output lib/ src/swagger-ui-spec.coffee ", (err, stdout, stderr) ->
    throw err if err
    notify 'compiled lib/swagger-ui-spec.js'
      
task 'buy_ingredients', 'Download dependencies from Github', ->
  request "https://raw.github.com/wordnik/swagger.js/master/lib/swagger.js", (err, response, body) ->
    fs.writeFile "lib/grounds/swagger.js", body, 'utf8', (err) ->
      throw err if err
      notify "Downloaded the latest swagger.js from Github"
 
notify = (message) -> 
  return unless message?
  options =
    title: 'CoffeeScript'
    image: 'lib/CoffeeScript.png'
  console.log message
  try require('growl') message, options