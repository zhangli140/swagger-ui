class ApiKeyButton extends Backbone.View
  initialize: ->

  render: ->
    template = @template()
    $(@el).html(template(@model))

    @

  events:
    "click #apikey_button" : "toggleApiKeyContainer"
    "click #apply_api_key" : "applyApiKey"

  applyApiKey: ->
    window.authorizations.add(@model.type, new ApiKeyAuthorization(@model.keyName, $("#input_apiKey_entry").val(), @model.passAs))
    window.swaggerUi.load()
    elem = $('#apikey_container').first().slideUp()

  toggleApiKeyContainer: ->
    if $('#apikey_container').length > 0
      elem = $('#apikey_container').first()
      if elem.is ':visible'
        elem.slideUp()
      else
        # hide others
        $('.auth_container').hide()
        elem.slideDown()

  template: ->
    Handlebars.templates.apikey_button_view
