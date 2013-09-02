class MainView extends Backbone.View
  initialize: ->

  events: {
#    'click .auth_icon'       : 'clickIcon'
  }

  render: ->
    # Render the outer container for resources
    $(@el).html(Handlebars.templates.main(@model))

    if @model.authSchemes
      authSchemes = @model.authSchemes
      for name of @model.authSchemes
        auth = authSchemes[name]
        if auth.type is "apiKey" and $("#apikey_button").length is 0
          button = new ApiKeyButton({model: auth}).render().el
          $('.auth_main_container').append button
        if auth.type is "basicAuth" and $("#basic_auth_button").length is 0
          button = new BasicAuthButton({model: auth}).render().el
          $('.auth_main_container').append button

    # Render each resource
    for resource in @model.apisArray
      @addResource resource
    @

  addResource: (resource) ->
    # Render a resource and add it to resources li
    resourceView = new ResourceView({model: resource, tagName: 'li', id: 'resource_' + resource.name, className: 'resource'})
    $('#resources').append resourceView.render().el

  clear: ->
    $(@el).html ''

  # handler for show signature
  clickIcon: (e) ->
    e?.preventDefault()
    alert(e)