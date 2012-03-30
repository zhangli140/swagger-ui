# handlebars.runtime-1.0.0.beta.6
# https://github.com/wycats/handlebars.js/downloads

# This line was modified from the handlebars source to make it globally available...
window.Handlebars = {}

# The rest is unmodified...
Handlebars.VERSION = "1.0.beta.6"
Handlebars.helpers = {}
Handlebars.partials = {}
Handlebars.registerHelper = (name, fn, inverse) ->
  fn.not = inverse  if inverse
  @helpers[name] = fn

Handlebars.registerPartial = (name, str) ->
  @partials[name] = str

Handlebars.registerHelper "helperMissing", (arg) ->
  if arguments.length is 2
    `undefined`
  else
    throw new Error("Could not find property '" + arg + "'")

toString = Object::toString
functionType = "[object Function]"
Handlebars.registerHelper "blockHelperMissing", (context, options) ->
  inverse = options.inverse or ->

  fn = options.fn
  ret = ""
  type = toString.call(context)
  context = context.call(this)  if type is functionType
  if context is true
    fn this
  else if context is false or not context?
    inverse this
  else if type is "[object Array]"
    if context.length > 0
      i = 0
      j = context.length

      while i < j
        ret = ret + fn(context[i])
        i++
    else
      ret = inverse(this)
    ret
  else
    fn context

Handlebars.registerHelper "each", (context, options) ->
  fn = options.fn
  inverse = options.inverse
  ret = ""
  if context and context.length > 0
    i = 0
    j = context.length

    while i < j
      ret = ret + fn(context[i])
      i++
  else
    ret = inverse(this)
  ret

Handlebars.registerHelper "if", (context, options) ->
  type = toString.call(context)
  context = context.call(this)  if type is functionType
  if not context or Handlebars.Utils.isEmpty(context)
    options.inverse this
  else
    options.fn this

Handlebars.registerHelper "unless", (context, options) ->
  fn = options.fn
  inverse = options.inverse
  options.fn = inverse
  options.inverse = fn
  Handlebars.helpers["if"].call this, context, options

Handlebars.registerHelper "with", (context, options) ->
  options.fn context

Handlebars.registerHelper "log", (context) ->
  Handlebars.log context

Handlebars.Exception = (message) ->
  tmp = Error::constructor.apply(this, arguments)
  for p of tmp
    this[p] = tmp[p]  if tmp.hasOwnProperty(p)
  @message = tmp.message

Handlebars.Exception:: = new Error
Handlebars.SafeString = (string) ->
  @string = string

Handlebars.SafeString::toString = ->
  @string.toString()

(->
  escape =
    "<": "&lt;"
    ">": "&gt;"
    "\"": "&quot;"
    "'": "&#x27;"
    "`": "&#x60;"

  badChars = /&(?!\w+;)|[<>"'`]/g
  possible = /[&<>"'`]/
  escapeChar = (chr) ->
    escape[chr] or "&amp;"

  Handlebars.Utils =
    escapeExpression: (string) ->
      if string instanceof Handlebars.SafeString
        return string.toString()
      else return ""  if not string? or string is false
      return string  unless possible.test(string)
      string.replace badChars, escapeChar

    isEmpty: (value) ->
      if typeof value is "undefined"
        true
      else if value is null
        true
      else if value is false
        true
      else if Object::toString.call(value) is "[object Array]" and value.length is 0
        true
      else
        false
)()
Handlebars.VM =
  template: (templateSpec) ->
    container =
      escapeExpression: Handlebars.Utils.escapeExpression
      invokePartial: Handlebars.VM.invokePartial
      programs: []
      program: (i, fn, data) ->
        programWrapper = @programs[i]
        if data
          Handlebars.VM.program fn, data
        else if programWrapper
          programWrapper
        else
          programWrapper = @programs[i] = Handlebars.VM.program(fn)
          programWrapper

      programWithDepth: Handlebars.VM.programWithDepth
      noop: Handlebars.VM.noop

    (context, options) ->
      options = options or {}
      templateSpec.call container, Handlebars, context, options.helpers, options.partials, options.data

  programWithDepth: (fn, data, $depth) ->
    args = Array::slice.call(arguments, 2)
    (context, options) ->
      options = options or {}
      fn.apply this, [ context, options.data or data ].concat(args)

  program: (fn, data) ->
    (context, options) ->
      options = options or {}
      fn context, options.data or data

  noop: ->
    ""

  invokePartial: (partial, name, context, helpers, partials, data) ->
    options =
      helpers: helpers
      partials: partials
      data: data

    if partial is `undefined`
      throw new Handlebars.Exception("The partial " + name + " could not be found")
    else if partial instanceof Function
      partial context, options
    else unless Handlebars.compile
      throw new Handlebars.Exception("The partial " + name + " could not be compiled when running in runtime-only mode")
    else
      partials[name] = Handlebars.compile(partial)
      partials[name] context, options

Handlebars.template = Handlebars.VM.template