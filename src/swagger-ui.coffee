class SwaggerUi
  
  # Defaults
  dom_id: "swagger_ui"

  # SwaggerUi accepts all the same options as SwaggerApi
  constructor: (options={}) ->

    # Allow dom_id to be overridden
    if options.dom_id?
      @dom_id = options.dom_id
      delete options.dom_id
      
    # Render when the @api object is ready
    options.success = @render
    
    # Initialize the API object
    @api = new SwaggerApi(options)
    
  render: =>
    
    # Create the DOM container if it doesn't exist
    $('body').append("<div id='#{@dom_id}'></div>") unless $("##{@dom_id}").length > 0

    # TODO: Precompile this template to reduce filesize and increase performance
    # http://handlebarsjs.com/precompilation.html
    # template = Handlebars.compile(window.swagger_template)
    
    # $("##{@dom_id}").append(template(@api))
    
    @ready = true
    @

window.SwaggerUi = SwaggerUi
    
# Handlebars.registerHelper "operationInput", (operation) ->
#   text = Handlebars.Utils.escapeExpression(text)
#   url = Handlebars.Utils.escapeExpression(url)
#   result = "<a href=\"" + url + "\">" + text + "</a>"
# 
#   # new Handlebars.SafeString(result)

