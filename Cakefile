fs     = require 'fs'
{exec} = require 'child_process'
util   = require 'util'
request = require 'request'

task 'watch', 'Watch all source files for changes and autocompile', ->
  notify "Watching source files for changes..."
  
  fs.watchFile "src/swagger-ui.coffee", (curr, prev) ->
    if +curr.mtime isnt +prev.mtime
      invoke 'bake'
      
  fs.watchFile "src/swagger-ui-spec.coffee", (curr, prev) ->
    if +curr.mtime isnt +prev.mtime
      invoke 'bakeSpec'

task 'updateSwagger', 'Download the lastest version of swagger.coffee from Github', ->
  request "https://raw.github.com/wordnik/swagger.js/master/src/swagger.coffee", (err, response, body) ->
    fs.writeFile "src/vendor/swagger.coffee", body, 'utf8', (err) ->
      throw err if err
      notify "Downloaded the latest swagger.coffee from Github"

task 'bakeSpec', 'Compile swagger-ui-spec.coffee to swagger-ui-spec.js', ->
  exec "coffee --compile --output lib/ src/swagger-ui-spec.coffee ", (err, stdout, stderr) ->
    throw err if err
    notify 'compiled lib/swagger-ui-spec.js'

task 'bake', 'Group coffee files and compile to swagger-ui.js', ->

  # Compile the spec
  invoke 'bakeSpec'

  beans = new Array
    
  # Add swagger.coffee
  fs.readFile "src/vendor/swagger.coffee", 'utf8', (err, swagger) ->
    throw err if err
    beans.push swagger

    # Add handlebars (runtime)
    fs.readFile "src/vendor/handlebars.runtime.coffee", 'utf8', (err, handlebars) ->
      throw err if err
      beans.push handlebars

      # Read the HTML template file
      fs.readFile "src/template.html", 'utf8', (err, templateContent) ->
        throw err if err

        # Store the template in a global variable.
        beans.push "window.swagger_template = \"#{templateContent}\""

        # Read swagger-ui.coffee
        fs.readFile "src/swagger-ui.coffee", 'utf8', (err, content) ->
          throw err if err
          beans.push content
          
          # Join coffee beans into a temporary coffee file
          fs.writeFile "swagger-ui.coffee", beans.join('\n\n'), 'utf8', (err) ->
            throw err if err
          
            # Compile to Javascript
            exec "coffee --compile --output lib/ swagger-ui.coffee ", (err, stdout, stderr) ->
              throw err if err
          
              # Remove the temporary coffee file
              fs.unlink "swagger-ui.coffee", (err) ->
                throw err if err
                notify 'compiled lib/swagger-ui.js'
                
notify = (message = '') -> 
    options = {
        title: 'CoffeeScript'
        image: 'lib/CoffeeScript.png'
    }
    console.log message
    try require('growl') message, options