class SwaggerUi
  
  # Defaults
  dom_id: "swagger-ui"
    
  constructor: (options={}) ->

    # Allow dom_id to be overridden
    if options.dom_id?
      @dom_id = options.dom_id
      delete options.dom_id
      
    # Render when the 
    options.success = @render
    
    # Initialize the API object
    @api = new SwaggerApi(options)
    
  render: ->
    console.log "render ui"

window.SwaggerUi = SwaggerUi
    
# Handlebars.registerHelper "operationInput", (operation) ->
#   text = Handlebars.Utils.escapeExpression(text)
#   url = Handlebars.Utils.escapeExpression(url)
#   result = "<a href=\"" + url + "\">" + text + "</a>"
# 
#   # new Handlebars.SafeString(result)    

