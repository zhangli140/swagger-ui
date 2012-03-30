fs     = require 'fs'
{exec} = require 'child_process'
request = require 'request'

task 'bake', 'Concatenate coffee-script files and compile to a single js file', ->

  beans = new Array
  
  # Download swagger.coffee directly from github
  request "https://raw.github.com/wordnik/swagger.js/master/src/swagger.coffee", (err, response, body) ->
    throw err if err
    beans.push body

    # Add handlebars
    fs.readFile "src/handlebars.coffee", 'utf8', (err, handlebars) ->
      throw err if err
      beans.push handlebars

      # Read the HTML template file
      fs.readFile "src/template.html", 'utf8', (err, templateContent) ->
        throw err if err

        # Store the template in a global variable.
        beans.push "window.SwaggerTemplate = \"#{templateContent}\""

        # Read swagger-ui.coffee
        fs.readFile "src/swagger-ui.coffee", 'utf8', (err, content) ->
          throw err if err
          beans.push content
          
          # Join coffee beans into a temporary coffee file
          fs.writeFile "swagger-ui.coffee", beans.join('\n\n'), 'utf8', (err) ->
            throw err if err
          
            # Compile to Javascript
            exec "coffee --compile swagger-ui.coffee", (err, stdout, stderr) ->
              throw err if err
          
              # Remove the temporary coffee file
              fs.unlink "swagger-ui.coffee", (err) ->
                throw err if err
                console.log '\nDing! swagger-ui.js is ready.\n'