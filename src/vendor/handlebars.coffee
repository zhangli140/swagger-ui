# handlebars-1.0.0.beta.6.js
# https://github.com/wycats/handlebars.js/downloads

# This line was modified from the handlebars source to make it globally available...
window.Handlebars = {}

# The rest is untouched
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

handlebars = (->
  parser =
    trace: trace = ->

    yy: {}
    symbols_:
      error: 2
      root: 3
      program: 4
      EOF: 5
      statements: 6
      simpleInverse: 7
      statement: 8
      openInverse: 9
      closeBlock: 10
      openBlock: 11
      mustache: 12
      partial: 13
      CONTENT: 14
      COMMENT: 15
      OPEN_BLOCK: 16
      inMustache: 17
      CLOSE: 18
      OPEN_INVERSE: 19
      OPEN_ENDBLOCK: 20
      path: 21
      OPEN: 22
      OPEN_UNESCAPED: 23
      OPEN_PARTIAL: 24
      params: 25
      hash: 26
      param: 27
      STRING: 28
      INTEGER: 29
      BOOLEAN: 30
      hashSegments: 31
      hashSegment: 32
      ID: 33
      EQUALS: 34
      pathSegments: 35
      SEP: 36
      $accept: 0
      $end: 1

    terminals_:
      2: "error"
      5: "EOF"
      14: "CONTENT"
      15: "COMMENT"
      16: "OPEN_BLOCK"
      18: "CLOSE"
      19: "OPEN_INVERSE"
      20: "OPEN_ENDBLOCK"
      22: "OPEN"
      23: "OPEN_UNESCAPED"
      24: "OPEN_PARTIAL"
      28: "STRING"
      29: "INTEGER"
      30: "BOOLEAN"
      33: "ID"
      34: "EQUALS"
      36: "SEP"

    productions_: [ 0, [ 3, 2 ], [ 4, 3 ], [ 4, 1 ], [ 4, 0 ], [ 6, 1 ], [ 6, 2 ], [ 8, 3 ], [ 8, 3 ], [ 8, 1 ], [ 8, 1 ], [ 8, 1 ], [ 8, 1 ], [ 11, 3 ], [ 9, 3 ], [ 10, 3 ], [ 12, 3 ], [ 12, 3 ], [ 13, 3 ], [ 13, 4 ], [ 7, 2 ], [ 17, 3 ], [ 17, 2 ], [ 17, 2 ], [ 17, 1 ], [ 25, 2 ], [ 25, 1 ], [ 27, 1 ], [ 27, 1 ], [ 27, 1 ], [ 27, 1 ], [ 26, 1 ], [ 31, 2 ], [ 31, 1 ], [ 32, 3 ], [ 32, 3 ], [ 32, 3 ], [ 32, 3 ], [ 21, 1 ], [ 35, 3 ], [ 35, 1 ] ]
    performAction: anonymous = (yytext, yyleng, yylineno, yy, yystate, $$, _$) ->
      $0 = $$.length - 1
      switch yystate
        when 1
          return $$[$0 - 1]
        when 2
          @$ = new yy.ProgramNode($$[$0 - 2], $$[$0])
        when 3
          @$ = new yy.ProgramNode($$[$0])
        when 4
          @$ = new yy.ProgramNode([])
        when 5
          @$ = [ $$[$0] ]
        when 6
          $$[$0 - 1].push $$[$0]
          @$ = $$[$0 - 1]
        when 7
          @$ = new yy.InverseNode($$[$0 - 2], $$[$0 - 1], $$[$0])
        when 8
          @$ = new yy.BlockNode($$[$0 - 2], $$[$0 - 1], $$[$0])
        when 9
          @$ = $$[$0]
        when 10
          @$ = $$[$0]
        when 11
          @$ = new yy.ContentNode($$[$0])
        when 12
          @$ = new yy.CommentNode($$[$0])
        when 13
          @$ = new yy.MustacheNode($$[$0 - 1][0], $$[$0 - 1][1])
        when 14
          @$ = new yy.MustacheNode($$[$0 - 1][0], $$[$0 - 1][1])
        when 15
          @$ = $$[$0 - 1]
        when 16
          @$ = new yy.MustacheNode($$[$0 - 1][0], $$[$0 - 1][1])
        when 17
          @$ = new yy.MustacheNode($$[$0 - 1][0], $$[$0 - 1][1], true)
        when 18
          @$ = new yy.PartialNode($$[$0 - 1])
        when 19
          @$ = new yy.PartialNode($$[$0 - 2], $$[$0 - 1])
        when 20, 21
          @$ = [ [ $$[$0 - 2] ].concat($$[$0 - 1]), $$[$0] ]
        when 22
          @$ = [ [ $$[$0 - 1] ].concat($$[$0]), null ]
        when 23
          @$ = [ [ $$[$0 - 1] ], $$[$0] ]
        when 24
          @$ = [ [ $$[$0] ], null ]
        when 25
          $$[$0 - 1].push $$[$0]
          @$ = $$[$0 - 1]
        when 26
          @$ = [ $$[$0] ]
        when 27
          @$ = $$[$0]
        when 28
          @$ = new yy.StringNode($$[$0])
        when 29
          @$ = new yy.IntegerNode($$[$0])
        when 30
          @$ = new yy.BooleanNode($$[$0])
        when 31
          @$ = new yy.HashNode($$[$0])
        when 32
          $$[$0 - 1].push $$[$0]
          @$ = $$[$0 - 1]
        when 33
          @$ = [ $$[$0] ]
        when 34
          @$ = [ $$[$0 - 2], $$[$0] ]
        when 35
          @$ = [ $$[$0 - 2], new yy.StringNode($$[$0]) ]
        when 36
          @$ = [ $$[$0 - 2], new yy.IntegerNode($$[$0]) ]
        when 37
          @$ = [ $$[$0 - 2], new yy.BooleanNode($$[$0]) ]
        when 38
          @$ = new yy.IdNode($$[$0])
        when 39
          $$[$0 - 2].push $$[$0]
          @$ = $$[$0 - 2]
        when 40
          @$ = [ $$[$0] ]

    table: [
      3: 1
      4: 2
      5: [ 2, 4 ]
      6: 3
      8: 4
      9: 5
      11: 6
      12: 7
      13: 8
      14: [ 1, 9 ]
      15: [ 1, 10 ]
      16: [ 1, 12 ]
      19: [ 1, 11 ]
      22: [ 1, 13 ]
      23: [ 1, 14 ]
      24: [ 1, 15 ]
    ,
      1: [ 3 ]
    ,
      5: [ 1, 16 ]
    ,
      5: [ 2, 3 ]
      7: 17
      8: 18
      9: 5
      11: 6
      12: 7
      13: 8
      14: [ 1, 9 ]
      15: [ 1, 10 ]
      16: [ 1, 12 ]
      19: [ 1, 19 ]
      20: [ 2, 3 ]
      22: [ 1, 13 ]
      23: [ 1, 14 ]
      24: [ 1, 15 ]
    ,
      5: [ 2, 5 ]
      14: [ 2, 5 ]
      15: [ 2, 5 ]
      16: [ 2, 5 ]
      19: [ 2, 5 ]
      20: [ 2, 5 ]
      22: [ 2, 5 ]
      23: [ 2, 5 ]
      24: [ 2, 5 ]
    ,
      4: 20
      6: 3
      8: 4
      9: 5
      11: 6
      12: 7
      13: 8
      14: [ 1, 9 ]
      15: [ 1, 10 ]
      16: [ 1, 12 ]
      19: [ 1, 11 ]
      20: [ 2, 4 ]
      22: [ 1, 13 ]
      23: [ 1, 14 ]
      24: [ 1, 15 ]
    ,
      4: 21
      6: 3
      8: 4
      9: 5
      11: 6
      12: 7
      13: 8
      14: [ 1, 9 ]
      15: [ 1, 10 ]
      16: [ 1, 12 ]
      19: [ 1, 11 ]
      20: [ 2, 4 ]
      22: [ 1, 13 ]
      23: [ 1, 14 ]
      24: [ 1, 15 ]
    ,
      5: [ 2, 9 ]
      14: [ 2, 9 ]
      15: [ 2, 9 ]
      16: [ 2, 9 ]
      19: [ 2, 9 ]
      20: [ 2, 9 ]
      22: [ 2, 9 ]
      23: [ 2, 9 ]
      24: [ 2, 9 ]
    ,
      5: [ 2, 10 ]
      14: [ 2, 10 ]
      15: [ 2, 10 ]
      16: [ 2, 10 ]
      19: [ 2, 10 ]
      20: [ 2, 10 ]
      22: [ 2, 10 ]
      23: [ 2, 10 ]
      24: [ 2, 10 ]
    ,
      5: [ 2, 11 ]
      14: [ 2, 11 ]
      15: [ 2, 11 ]
      16: [ 2, 11 ]
      19: [ 2, 11 ]
      20: [ 2, 11 ]
      22: [ 2, 11 ]
      23: [ 2, 11 ]
      24: [ 2, 11 ]
    ,
      5: [ 2, 12 ]
      14: [ 2, 12 ]
      15: [ 2, 12 ]
      16: [ 2, 12 ]
      19: [ 2, 12 ]
      20: [ 2, 12 ]
      22: [ 2, 12 ]
      23: [ 2, 12 ]
      24: [ 2, 12 ]
    ,
      17: 22
      21: 23
      33: [ 1, 25 ]
      35: 24
    ,
      17: 26
      21: 23
      33: [ 1, 25 ]
      35: 24
    ,
      17: 27
      21: 23
      33: [ 1, 25 ]
      35: 24
    ,
      17: 28
      21: 23
      33: [ 1, 25 ]
      35: 24
    ,
      21: 29
      33: [ 1, 25 ]
      35: 24
    ,
      1: [ 2, 1 ]
    ,
      6: 30
      8: 4
      9: 5
      11: 6
      12: 7
      13: 8
      14: [ 1, 9 ]
      15: [ 1, 10 ]
      16: [ 1, 12 ]
      19: [ 1, 11 ]
      22: [ 1, 13 ]
      23: [ 1, 14 ]
      24: [ 1, 15 ]
    ,
      5: [ 2, 6 ]
      14: [ 2, 6 ]
      15: [ 2, 6 ]
      16: [ 2, 6 ]
      19: [ 2, 6 ]
      20: [ 2, 6 ]
      22: [ 2, 6 ]
      23: [ 2, 6 ]
      24: [ 2, 6 ]
    ,
      17: 22
      18: [ 1, 31 ]
      21: 23
      33: [ 1, 25 ]
      35: 24
    ,
      10: 32
      20: [ 1, 33 ]
    ,
      10: 34
      20: [ 1, 33 ]
    ,
      18: [ 1, 35 ]
    ,
      18: [ 2, 24 ]
      21: 40
      25: 36
      26: 37
      27: 38
      28: [ 1, 41 ]
      29: [ 1, 42 ]
      30: [ 1, 43 ]
      31: 39
      32: 44
      33: [ 1, 45 ]
      35: 24
    ,
      18: [ 2, 38 ]
      28: [ 2, 38 ]
      29: [ 2, 38 ]
      30: [ 2, 38 ]
      33: [ 2, 38 ]
      36: [ 1, 46 ]
    ,
      18: [ 2, 40 ]
      28: [ 2, 40 ]
      29: [ 2, 40 ]
      30: [ 2, 40 ]
      33: [ 2, 40 ]
      36: [ 2, 40 ]
    ,
      18: [ 1, 47 ]
    ,
      18: [ 1, 48 ]
    ,
      18: [ 1, 49 ]
    ,
      18: [ 1, 50 ]
      21: 51
      33: [ 1, 25 ]
      35: 24
    ,
      5: [ 2, 2 ]
      8: 18
      9: 5
      11: 6
      12: 7
      13: 8
      14: [ 1, 9 ]
      15: [ 1, 10 ]
      16: [ 1, 12 ]
      19: [ 1, 11 ]
      20: [ 2, 2 ]
      22: [ 1, 13 ]
      23: [ 1, 14 ]
      24: [ 1, 15 ]
    ,
      14: [ 2, 20 ]
      15: [ 2, 20 ]
      16: [ 2, 20 ]
      19: [ 2, 20 ]
      22: [ 2, 20 ]
      23: [ 2, 20 ]
      24: [ 2, 20 ]
    ,
      5: [ 2, 7 ]
      14: [ 2, 7 ]
      15: [ 2, 7 ]
      16: [ 2, 7 ]
      19: [ 2, 7 ]
      20: [ 2, 7 ]
      22: [ 2, 7 ]
      23: [ 2, 7 ]
      24: [ 2, 7 ]
    ,
      21: 52
      33: [ 1, 25 ]
      35: 24
    ,
      5: [ 2, 8 ]
      14: [ 2, 8 ]
      15: [ 2, 8 ]
      16: [ 2, 8 ]
      19: [ 2, 8 ]
      20: [ 2, 8 ]
      22: [ 2, 8 ]
      23: [ 2, 8 ]
      24: [ 2, 8 ]
    ,
      14: [ 2, 14 ]
      15: [ 2, 14 ]
      16: [ 2, 14 ]
      19: [ 2, 14 ]
      20: [ 2, 14 ]
      22: [ 2, 14 ]
      23: [ 2, 14 ]
      24: [ 2, 14 ]
    ,
      18: [ 2, 22 ]
      21: 40
      26: 53
      27: 54
      28: [ 1, 41 ]
      29: [ 1, 42 ]
      30: [ 1, 43 ]
      31: 39
      32: 44
      33: [ 1, 45 ]
      35: 24
    ,
      18: [ 2, 23 ]
    ,
      18: [ 2, 26 ]
      28: [ 2, 26 ]
      29: [ 2, 26 ]
      30: [ 2, 26 ]
      33: [ 2, 26 ]
    ,
      18: [ 2, 31 ]
      32: 55
      33: [ 1, 56 ]
    ,
      18: [ 2, 27 ]
      28: [ 2, 27 ]
      29: [ 2, 27 ]
      30: [ 2, 27 ]
      33: [ 2, 27 ]
    ,
      18: [ 2, 28 ]
      28: [ 2, 28 ]
      29: [ 2, 28 ]
      30: [ 2, 28 ]
      33: [ 2, 28 ]
    ,
      18: [ 2, 29 ]
      28: [ 2, 29 ]
      29: [ 2, 29 ]
      30: [ 2, 29 ]
      33: [ 2, 29 ]
    ,
      18: [ 2, 30 ]
      28: [ 2, 30 ]
      29: [ 2, 30 ]
      30: [ 2, 30 ]
      33: [ 2, 30 ]
    ,
      18: [ 2, 33 ]
      33: [ 2, 33 ]
    ,
      18: [ 2, 40 ]
      28: [ 2, 40 ]
      29: [ 2, 40 ]
      30: [ 2, 40 ]
      33: [ 2, 40 ]
      34: [ 1, 57 ]
      36: [ 2, 40 ]
    ,
      33: [ 1, 58 ]
    ,
      14: [ 2, 13 ]
      15: [ 2, 13 ]
      16: [ 2, 13 ]
      19: [ 2, 13 ]
      20: [ 2, 13 ]
      22: [ 2, 13 ]
      23: [ 2, 13 ]
      24: [ 2, 13 ]
    ,
      5: [ 2, 16 ]
      14: [ 2, 16 ]
      15: [ 2, 16 ]
      16: [ 2, 16 ]
      19: [ 2, 16 ]
      20: [ 2, 16 ]
      22: [ 2, 16 ]
      23: [ 2, 16 ]
      24: [ 2, 16 ]
    ,
      5: [ 2, 17 ]
      14: [ 2, 17 ]
      15: [ 2, 17 ]
      16: [ 2, 17 ]
      19: [ 2, 17 ]
      20: [ 2, 17 ]
      22: [ 2, 17 ]
      23: [ 2, 17 ]
      24: [ 2, 17 ]
    ,
      5: [ 2, 18 ]
      14: [ 2, 18 ]
      15: [ 2, 18 ]
      16: [ 2, 18 ]
      19: [ 2, 18 ]
      20: [ 2, 18 ]
      22: [ 2, 18 ]
      23: [ 2, 18 ]
      24: [ 2, 18 ]
    ,
      18: [ 1, 59 ]
    ,
      18: [ 1, 60 ]
    ,
      18: [ 2, 21 ]
    ,
      18: [ 2, 25 ]
      28: [ 2, 25 ]
      29: [ 2, 25 ]
      30: [ 2, 25 ]
      33: [ 2, 25 ]
    ,
      18: [ 2, 32 ]
      33: [ 2, 32 ]
    ,
      34: [ 1, 57 ]
    ,
      21: 61
      28: [ 1, 62 ]
      29: [ 1, 63 ]
      30: [ 1, 64 ]
      33: [ 1, 25 ]
      35: 24
    ,
      18: [ 2, 39 ]
      28: [ 2, 39 ]
      29: [ 2, 39 ]
      30: [ 2, 39 ]
      33: [ 2, 39 ]
      36: [ 2, 39 ]
    ,
      5: [ 2, 19 ]
      14: [ 2, 19 ]
      15: [ 2, 19 ]
      16: [ 2, 19 ]
      19: [ 2, 19 ]
      20: [ 2, 19 ]
      22: [ 2, 19 ]
      23: [ 2, 19 ]
      24: [ 2, 19 ]
    ,
      5: [ 2, 15 ]
      14: [ 2, 15 ]
      15: [ 2, 15 ]
      16: [ 2, 15 ]
      19: [ 2, 15 ]
      20: [ 2, 15 ]
      22: [ 2, 15 ]
      23: [ 2, 15 ]
      24: [ 2, 15 ]
    ,
      18: [ 2, 34 ]
      33: [ 2, 34 ]
    ,
      18: [ 2, 35 ]
      33: [ 2, 35 ]
    ,
      18: [ 2, 36 ]
      33: [ 2, 36 ]
    ,
      18: [ 2, 37 ]
      33: [ 2, 37 ]
     ]
    defaultActions:
      16: [ 2, 1 ]
      37: [ 2, 23 ]
      53: [ 2, 21 ]

    parseError: parseError = (str, hash) ->
      throw new Error(str)

    parse: parse = (input) ->
      popStack = (n) ->
        stack.length = stack.length - 2 * n
        vstack.length = vstack.length - n
        lstack.length = lstack.length - n
      lex = ->
        token = undefined
        token = self.lexer.lex() or 1
        token = self.symbols_[token] or token  if typeof token isnt "number"
        token
      self = this
      stack = [ 0 ]
      vstack = [ null ]
      lstack = []
      table = @table
      yytext = ""
      yylineno = 0
      yyleng = 0
      recovering = 0
      TERROR = 2
      EOF = 1
      @lexer.setInput input
      @lexer.yy = @yy
      @yy.lexer = @lexer
      @lexer.yylloc = {}  if typeof @lexer.yylloc is "undefined"
      yyloc = @lexer.yylloc
      lstack.push yyloc
      @parseError = @yy.parseError  if typeof @yy.parseError is "function"
      symbol = undefined
      preErrorSymbol = undefined
      state = undefined
      action = undefined
      a = undefined
      r = undefined
      yyval = {}
      p = undefined
      len = undefined
      newState = undefined
      expected = undefined
      loop
        state = stack[stack.length - 1]
        if @defaultActions[state]
          action = @defaultActions[state]
        else
          symbol = lex()  unless symbol?
          action = table[state] and table[state][symbol]
        if typeof action is "undefined" or not action.length or not action[0]
          unless recovering
            expected = []
            for p of table[state]
              expected.push "'" + @terminals_[p] + "'"  if @terminals_[p] and p > 2
            errStr = ""
            if @lexer.showPosition
              errStr = "Parse error on line " + (yylineno + 1) + ":\n" + @lexer.showPosition() + "\nExpecting " + expected.join(", ") + ", got '" + @terminals_[symbol] + "'"
            else
              errStr = "Parse error on line " + (yylineno + 1) + ": Unexpected " + (if symbol is 1 then "end of input" else "'" + (@terminals_[symbol] or symbol) + "'")
            @parseError errStr,
              text: @lexer.match
              token: @terminals_[symbol] or symbol
              line: @lexer.yylineno
              loc: yyloc
              expected: expected
        throw new Error("Parse Error: multiple actions possible at state: " + state + ", token: " + symbol)  if action[0] instanceof Array and action.length > 1
        switch action[0]
          when 1
            stack.push symbol
            vstack.push @lexer.yytext
            lstack.push @lexer.yylloc
            stack.push action[1]
            symbol = null
            unless preErrorSymbol
              yyleng = @lexer.yyleng
              yytext = @lexer.yytext
              yylineno = @lexer.yylineno
              yyloc = @lexer.yylloc
              recovering--  if recovering > 0
            else
              symbol = preErrorSymbol
              preErrorSymbol = null
          when 2
            len = @productions_[action[1]][1]
            yyval.$ = vstack[vstack.length - len]
            yyval._$ =
              first_line: lstack[lstack.length - (len or 1)].first_line
              last_line: lstack[lstack.length - 1].last_line
              first_column: lstack[lstack.length - (len or 1)].first_column
              last_column: lstack[lstack.length - 1].last_column

            r = @performAction.call(yyval, yytext, yyleng, yylineno, @yy, action[1], vstack, lstack)
            return r  if typeof r isnt "undefined"
            if len
              stack = stack.slice(0, -1 * len * 2)
              vstack = vstack.slice(0, -1 * len)
              lstack = lstack.slice(0, -1 * len)
            stack.push @productions_[action[1]][0]
            vstack.push yyval.$
            lstack.push yyval._$
            newState = table[stack[stack.length - 2]][stack[stack.length - 1]]
            stack.push newState
          when 3
            return true
      true

  lexer = (->
    lexer = (
      EOF: 1
      parseError: parseError = (str, hash) ->
        if @yy.parseError
          @yy.parseError str, hash
        else
          throw new Error(str)

      setInput: (input) ->
        @_input = input
        @_more = @_less = @done = false
        @yylineno = @yyleng = 0
        @yytext = @matched = @match = ""
        @conditionStack = [ "INITIAL" ]
        @yylloc =
          first_line: 1
          first_column: 0
          last_line: 1
          last_column: 0

        this

      input: ->
        ch = @_input[0]
        @yytext += ch
        @yyleng++
        @match += ch
        @matched += ch
        lines = ch.match(/\n/)
        @yylineno++  if lines
        @_input = @_input.slice(1)
        ch

      unput: (ch) ->
        @_input = ch + @_input
        this

      more: ->
        @_more = true
        this

      pastInput: ->
        past = @matched.substr(0, @matched.length - @match.length)
        (if past.length > 20 then "..." else "") + past.substr(-20).replace(/\n/g, "")

      upcomingInput: ->
        next = @match
        next += @_input.substr(0, 20 - next.length)  if next.length < 20
        (next.substr(0, 20) + (if next.length > 20 then "..." else "")).replace /\n/g, ""

      showPosition: ->
        pre = @pastInput()
        c = new Array(pre.length + 1).join("-")
        pre + @upcomingInput() + "\n" + c + "^"

      next: ->
        return @EOF  if @done
        @done = true  unless @_input
        token = undefined
        match = undefined
        col = undefined
        lines = undefined
        unless @_more
          @yytext = ""
          @match = ""
        rules = @_currentRules()
        i = 0

        while i < rules.length
          match = @_input.match(@rules[rules[i]])
          if match
            lines = match[0].match(/\n.*/g)
            @yylineno += lines.length  if lines
            @yylloc =
              first_line: @yylloc.last_line
              last_line: @yylineno + 1
              first_column: @yylloc.last_column
              last_column: (if lines then lines[lines.length - 1].length - 1 else @yylloc.last_column + match[0].length)

            @yytext += match[0]
            @match += match[0]
            @matches = match
            @yyleng = @yytext.length
            @_more = false
            @_input = @_input.slice(match[0].length)
            @matched += match[0]
            token = @performAction.call(this, @yy, this, rules[i], @conditionStack[@conditionStack.length - 1])
            if token
              return token
            else
              return
          i++
        if @_input is ""
          @EOF
        else
          @parseError "Lexical error on line " + (@yylineno + 1) + ". Unrecognized text.\n" + @showPosition(),
            text: ""
            token: null
            line: @yylineno

      lex: lex = ->
        r = @next()
        if typeof r isnt "undefined"
          r
        else
          @lex()

      begin: begin = (condition) ->
        @conditionStack.push condition

      popState: popState = ->
        @conditionStack.pop()

      _currentRules: _currentRules = ->
        @conditions[@conditionStack[@conditionStack.length - 1]].rules

      topState: ->
        @conditionStack[@conditionStack.length - 2]

      pushState: begin = (condition) ->
        @begin condition
    )
    lexer.performAction = anonymous = (yy, yy_, $avoiding_name_collisions, YY_START) ->
      YYSTATE = YY_START
      switch $avoiding_name_collisions
        when 0
          @begin "mu"  if yy_.yytext.slice(-1) isnt "\\"
          if yy_.yytext.slice(-1) is "\\"
            yy_.yytext = yy_.yytext.substr(0, yy_.yyleng - 1)
            @begin("emu")
          return 14  if yy_.yytext
        when 1
          return 14
        when 2
          @popState()
          return 14
        when 3
          return 24
        when 4
          return 16
        when 5
          return 20
        when 6
          return 19
        when 7
          return 19
        when 8
          return 23
        when 9
          return 23
        when 10
          yy_.yytext = yy_.yytext.substr(3, yy_.yyleng - 5)
          @popState()
          return 15
        when 11
          return 22
        when 12
          return 34
        when 13
          return 33
        when 14
          return 33
        when 15
          return 36
        when 16, 17
          @popState()
          return 18
        when 18
          @popState()
          return 18
        when 19
          yy_.yytext = yy_.yytext.substr(1, yy_.yyleng - 2).replace(/\\"/g, "\"")
          return 28
        when 20
          return 30
        when 21
          return 30
        when 22
          return 29
        when 23
          return 33
        when 24
          yy_.yytext = yy_.yytext.substr(1, yy_.yyleng - 2)
          return 33
        when 25
          return "INVALID"
        when 26
          return 5

    lexer.rules = [ /^[^\x00]*?(?=(\{\{))/, /^[^\x00]+/, /^[^\x00]{2,}?(?=(\{\{))/, /^\{\{>/, /^\{\{#/, /^\{\{\//, /^\{\{\^/, /^\{\{\s*else\b/, /^\{\{\{/, /^\{\{&/, /^\{\{![\s\S]*?\}\}/, /^\{\{/, /^=/, /^\.(?=[} ])/, /^\.\./, /^[\/.]/, /^\s+/, /^\}\}\}/, /^\}\}/, /^"(\\["]|[^"])*"/, /^true(?=[}\s])/, /^false(?=[}\s])/, /^[0-9]+(?=[}\s])/, /^[a-zA-Z0-9_$-]+(?=[=}\s\/.])/, /^\[[^\]]*\]/, /^./, /^$/ ]
    lexer.conditions =
      mu:
        rules: [ 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 ]
        inclusive: false

      emu:
        rules: [ 2 ]
        inclusive: false

      INITIAL:
        rules: [ 0, 1, 26 ]
        inclusive: true

    lexer
  )()
  parser.lexer = lexer
  parser
)()
if typeof require isnt "undefined" and typeof exports isnt "undefined"
  exports.parser = handlebars
  exports.parse = ->
    handlebars.parse.apply handlebars, arguments

  exports.main = commonjsMain = (args) ->
    throw new Error("Usage: " + args[0] + " FILE")  unless args[1]
    if typeof process isnt "undefined"
      source = require("fs").readFileSync(require("path").join(process.cwd(), args[1]), "utf8")
    else
      cwd = require("file").path(require("file").cwd())
      source = cwd.join(args[1]).read(charset: "utf-8")
    exports.parser.parse source

  exports.main (if typeof process isnt "undefined" then process.argv.slice(1) else require("system").args)  if typeof module isnt "undefined" and require.main is module
Handlebars.Parser = handlebars
Handlebars.parse = (string) ->
  Handlebars.Parser.yy = Handlebars.AST
  Handlebars.Parser.parse string

Handlebars.print = (ast) ->
  new Handlebars.PrintVisitor().accept ast

Handlebars.logger =
  DEBUG: 0
  INFO: 1
  WARN: 2
  ERROR: 3
  level: 3
  log: (level, str) ->

Handlebars.log = (level, str) ->
  Handlebars.logger.log level, str

(->
  Handlebars.AST = {}
  Handlebars.AST.ProgramNode = (statements, inverse) ->
    @type = "program"
    @statements = statements
    @inverse = new Handlebars.AST.ProgramNode(inverse)  if inverse

  Handlebars.AST.MustacheNode = (params, hash, unescaped) ->
    @type = "mustache"
    @id = params[0]
    @params = params.slice(1)
    @hash = hash
    @escaped = not unescaped

  Handlebars.AST.PartialNode = (id, context) ->
    @type = "partial"
    @id = id
    @context = context

  verifyMatch = (open, close) ->
    throw new Handlebars.Exception(open.original + " doesn't match " + close.original)  if open.original isnt close.original

  Handlebars.AST.BlockNode = (mustache, program, close) ->
    verifyMatch mustache.id, close
    @type = "block"
    @mustache = mustache
    @program = program

  Handlebars.AST.InverseNode = (mustache, program, close) ->
    verifyMatch mustache.id, close
    @type = "inverse"
    @mustache = mustache
    @program = program

  Handlebars.AST.ContentNode = (string) ->
    @type = "content"
    @string = string

  Handlebars.AST.HashNode = (pairs) ->
    @type = "hash"
    @pairs = pairs

  Handlebars.AST.IdNode = (parts) ->
    @type = "ID"
    @original = parts.join(".")
    dig = []
    depth = 0
    i = 0
    l = parts.length

    while i < l
      part = parts[i]
      if part is ".."
        depth++
      else if part is "." or part is "this"
        @isScoped = true
      else
        dig.push part
      i++
    @parts = dig
    @string = dig.join(".")
    @depth = depth
    @isSimple = (dig.length is 1) and (depth is 0)

  Handlebars.AST.StringNode = (string) ->
    @type = "STRING"
    @string = string

  Handlebars.AST.IntegerNode = (integer) ->
    @type = "INTEGER"
    @integer = integer

  Handlebars.AST.BooleanNode = (bool) ->
    @type = "BOOLEAN"
    @bool = bool

  Handlebars.AST.CommentNode = (comment) ->
    @type = "comment"
    @comment = comment
)()
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
Handlebars.Compiler = ->

Handlebars.JavaScriptCompiler = ->

((Compiler, JavaScriptCompiler) ->
  Compiler.OPCODE_MAP =
    appendContent: 1
    getContext: 2
    lookupWithHelpers: 3
    lookup: 4
    append: 5
    invokeMustache: 6
    appendEscaped: 7
    pushString: 8
    truthyOrFallback: 9
    functionOrFallback: 10
    invokeProgram: 11
    invokePartial: 12
    push: 13
    assignToHash: 15
    pushStringParam: 16

  Compiler.MULTI_PARAM_OPCODES =
    appendContent: 1
    getContext: 1
    lookupWithHelpers: 2
    lookup: 1
    invokeMustache: 3
    pushString: 1
    truthyOrFallback: 1
    functionOrFallback: 1
    invokeProgram: 3
    invokePartial: 1
    push: 1
    assignToHash: 1
    pushStringParam: 1

  Compiler.DISASSEMBLE_MAP = {}
  for prop of Compiler.OPCODE_MAP
    value = Compiler.OPCODE_MAP[prop]
    Compiler.DISASSEMBLE_MAP[value] = prop
  Compiler.multiParamSize = (code) ->
    Compiler.MULTI_PARAM_OPCODES[Compiler.DISASSEMBLE_MAP[code]]

  Compiler:: =
    compiler: Compiler
    disassemble: ->
      opcodes = @opcodes
      opcode = undefined
      nextCode = undefined
      out = []
      str = undefined
      name = undefined
      value = undefined
      i = 0
      l = opcodes.length

      while i < l
        opcode = opcodes[i]
        if opcode is "DECLARE"
          name = opcodes[++i]
          value = opcodes[++i]
          out.push "DECLARE " + name + " = " + value
        else
          str = Compiler.DISASSEMBLE_MAP[opcode]
          extraParams = Compiler.multiParamSize(opcode)
          codes = []
          j = 0

          while j < extraParams
            nextCode = opcodes[++i]
            nextCode = "\"" + nextCode.replace("\n", "\\n") + "\""  if typeof nextCode is "string"
            codes.push nextCode
            j++
          str = str + " " + codes.join(" ")
          out.push str
        i++
      out.join "\n"

    guid: 0
    compile: (program, options) ->
      @children = []
      @depths = list: []
      @options = options
      knownHelpers = @options.knownHelpers
      @options.knownHelpers =
        helperMissing: true
        blockHelperMissing: true
        each: true
        if: true
        unless: true
        with: true
        log: true

      if knownHelpers
        for name of knownHelpers
          @options.knownHelpers[name] = knownHelpers[name]
      @program program

    accept: (node) ->
      this[node.type] node

    program: (program) ->
      statements = program.statements
      statement = undefined
      @opcodes = []
      i = 0
      l = statements.length

      while i < l
        statement = statements[i]
        this[statement.type] statement
        i++
      @isSimple = l is 1
      @depths.list = @depths.list.sort((a, b) ->
        a - b
      )
      this

    compileProgram: (program) ->
      result = new @compiler().compile(program, @options)
      guid = @guid++
      @usePartial = @usePartial or result.usePartial
      @children[guid] = result
      i = 0
      l = result.depths.list.length

      while i < l
        depth = result.depths.list[i]
        if depth < 2
          continue
        else
          @addDepth depth - 1
        i++
      guid

    block: (block) ->
      mustache = block.mustache
      depth = undefined
      child = undefined
      inverse = undefined
      inverseGuid = undefined
      params = @setupStackForMustache(mustache)
      programGuid = @compileProgram(block.program)
      if block.program.inverse
        inverseGuid = @compileProgram(block.program.inverse)
        @declare "inverse", inverseGuid
      @opcode "invokeProgram", programGuid, params.length, !!mustache.hash
      @declare "inverse", null
      @opcode "append"

    inverse: (block) ->
      params = @setupStackForMustache(block.mustache)
      programGuid = @compileProgram(block.program)
      @declare "inverse", programGuid
      @opcode "invokeProgram", null, params.length, !!block.mustache.hash
      @declare "inverse", null
      @opcode "append"

    hash: (hash) ->
      pairs = hash.pairs
      pair = undefined
      val = undefined
      @opcode "push", "{}"
      i = 0
      l = pairs.length

      while i < l
        pair = pairs[i]
        val = pair[1]
        @accept val
        @opcode "assignToHash", pair[0]
        i++

    partial: (partial) ->
      id = partial.id
      @usePartial = true
      if partial.context
        @ID partial.context
      else
        @opcode "push", "depth0"
      @opcode "invokePartial", id.original
      @opcode "append"

    content: (content) ->
      @opcode "appendContent", content.string

    mustache: (mustache) ->
      params = @setupStackForMustache(mustache)
      @opcode "invokeMustache", params.length, mustache.id.original, !!mustache.hash
      if mustache.escaped and not @options.noEscape
        @opcode "appendEscaped"
      else
        @opcode "append"

    ID: (id) ->
      @addDepth id.depth
      @opcode "getContext", id.depth
      @opcode "lookupWithHelpers", id.parts[0] or null, id.isScoped or false
      i = 1
      l = id.parts.length

      while i < l
        @opcode "lookup", id.parts[i]
        i++

    STRING: (string) ->
      @opcode "pushString", string.string

    INTEGER: (integer) ->
      @opcode "push", integer.integer

    BOOLEAN: (bool) ->
      @opcode "push", bool.bool

    comment: ->

    pushParams: (params) ->
      i = params.length
      param = undefined
      while i--
        param = params[i]
        if @options.stringParams
          @addDepth param.depth  if param.depth
          @opcode "getContext", param.depth or 0
          @opcode "pushStringParam", param.string
        else
          this[param.type] param

    opcode: (name, val1, val2, val3) ->
      @opcodes.push Compiler.OPCODE_MAP[name]
      @opcodes.push val1  if val1 isnt `undefined`
      @opcodes.push val2  if val2 isnt `undefined`
      @opcodes.push val3  if val3 isnt `undefined`

    declare: (name, value) ->
      @opcodes.push "DECLARE"
      @opcodes.push name
      @opcodes.push value

    addDepth: (depth) ->
      return  if depth is 0
      unless @depths[depth]
        @depths[depth] = true
        @depths.list.push depth

    setupStackForMustache: (mustache) ->
      params = mustache.params
      @pushParams params
      @hash mustache.hash  if mustache.hash
      @ID mustache.id
      params

  JavaScriptCompiler:: =
    nameLookup: (parent, name, type) ->
      if /^[0-9]+$/.test(name)
        parent + "[" + name + "]"
      else if JavaScriptCompiler.isValidJavaScriptVariableName(name)
        parent + "." + name
      else
        parent + "['" + name + "']"

    appendToBuffer: (string) ->
      if @environment.isSimple
        "return " + string + ";"
      else
        "buffer += " + string + ";"

    initializeBuffer: ->
      @quotedString ""

    namespace: "Handlebars"
    compile: (environment, options, context, asObject) ->
      @environment = environment
      @options = options or {}
      @name = @environment.name
      @isChild = !!context
      @context = context or
        programs: []
        aliases:
          self: "this"

        registers:
          list: []

      @preamble()
      @stackSlot = 0
      @stackVars = []
      @compileChildren environment, options
      opcodes = environment.opcodes
      opcode = undefined
      @i = 0
      l = opcodes.length
      while @i < l
        opcode = @nextOpcode(0)
        if opcode[0] is "DECLARE"
          @i = @i + 2
          this[opcode[1]] = opcode[2]
        else
          @i = @i + opcode[1].length
          this[opcode[0]].apply this, opcode[1]
        @i++
      @createFunctionContext asObject

    nextOpcode: (n) ->
      opcodes = @environment.opcodes
      opcode = opcodes[@i + n]
      name = undefined
      val = undefined
      extraParams = undefined
      codes = undefined
      if opcode is "DECLARE"
        name = opcodes[@i + 1]
        val = opcodes[@i + 2]
        [ "DECLARE", name, val ]
      else
        name = Compiler.DISASSEMBLE_MAP[opcode]
        extraParams = Compiler.multiParamSize(opcode)
        codes = []
        j = 0

        while j < extraParams
          codes.push opcodes[@i + j + 1 + n]
          j++
        [ name, codes ]

    eat: (opcode) ->
      @i = @i + opcode.length

    preamble: ->
      out = []
      @useRegister "foundHelper"
      unless @isChild
        namespace = @namespace
        copies = "helpers = helpers || " + namespace + ".helpers;"
        copies = copies + " partials = partials || " + namespace + ".partials;"  if @environment.usePartial
        out.push copies
      else
        out.push ""
      unless @environment.isSimple
        out.push ", buffer = " + @initializeBuffer()
      else
        out.push ""
      @lastContext = 0
      @source = out

    createFunctionContext: (asObject) ->
      locals = @stackVars
      locals = locals.concat(@context.registers.list)  unless @isChild
      @source[1] = @source[1] + ", " + locals.join(", ")  if locals.length > 0
      unless @isChild
        aliases = []
        for alias of @context.aliases
          @source[1] = @source[1] + ", " + alias + "=" + @context.aliases[alias]
      @source[1] = "var " + @source[1].substring(2) + ";"  if @source[1]
      @source[1] += "\n" + @context.programs.join("\n") + "\n"  unless @isChild
      @source.push "return buffer;"  unless @environment.isSimple
      params = (if @isChild then [ "depth0", "data" ] else [ "Handlebars", "depth0", "helpers", "partials", "data" ])
      i = 0
      l = @environment.depths.list.length

      while i < l
        params.push "depth" + @environment.depths.list[i]
        i++
      if asObject
        params.push @source.join("\n  ")
        Function.apply this, params
      else
        functionSource = "function " + (@name or "") + "(" + params.join(",") + ") {\n  " + @source.join("\n  ") + "}"
        Handlebars.log Handlebars.logger.DEBUG, functionSource + "\n\n"
        functionSource

    appendContent: (content) ->
      @source.push @appendToBuffer(@quotedString(content))

    append: ->
      local = @popStack()
      @source.push "if(" + local + " || " + local + " === 0) { " + @appendToBuffer(local) + " }"
      @source.push "else { " + @appendToBuffer("''") + " }"  if @environment.isSimple

    appendEscaped: ->
      opcode = @nextOpcode(1)
      extra = ""
      @context.aliases.escapeExpression = "this.escapeExpression"
      if opcode[0] is "appendContent"
        extra = " + " + @quotedString(opcode[1][0])
        @eat opcode
      @source.push @appendToBuffer("escapeExpression(" + @popStack() + ")" + extra)

    getContext: (depth) ->
      @lastContext = depth  if @lastContext isnt depth

    lookupWithHelpers: (name, isScoped) ->
      if name
        topStack = @nextStack()
        @usingKnownHelper = false
        toPush = undefined
        if not isScoped and @options.knownHelpers[name]
          toPush = topStack + " = " + @nameLookup("helpers", name, "helper")
          @usingKnownHelper = true
        else if isScoped or @options.knownHelpersOnly
          toPush = topStack + " = " + @nameLookup("depth" + @lastContext, name, "context")
        else
          @register "foundHelper", @nameLookup("helpers", name, "helper")
          toPush = topStack + " = foundHelper || " + @nameLookup("depth" + @lastContext, name, "context")
        toPush += ";"
        @source.push toPush
      else
        @pushStack "depth" + @lastContext

    lookup: (name) ->
      topStack = @topStack()
      @source.push topStack + " = (" + topStack + " === null || " + topStack + " === undefined || " + topStack + " === false ? " + topStack + " : " + @nameLookup(topStack, name, "context") + ");"

    pushStringParam: (string) ->
      @pushStack "depth" + @lastContext
      @pushString string

    pushString: (string) ->
      @pushStack @quotedString(string)

    push: (name) ->
      @pushStack name

    invokeMustache: (paramSize, original, hasHash) ->
      @populateParams paramSize, @quotedString(original), "{}", null, hasHash, (nextStack, helperMissingString, id) ->
        unless @usingKnownHelper
          @context.aliases.helperMissing = "helpers.helperMissing"
          @context.aliases.undef = "void 0"
          @source.push "else if(" + id + "=== undef) { " + nextStack + " = helperMissing.call(" + helperMissingString + "); }"
          @source.push "else { " + nextStack + " = " + id + "; }"  if nextStack isnt id

    invokeProgram: (guid, paramSize, hasHash) ->
      inverse = @programExpression(@inverse)
      mainProgram = @programExpression(guid)
      @populateParams paramSize, null, mainProgram, inverse, hasHash, (nextStack, helperMissingString, id) ->
        unless @usingKnownHelper
          @context.aliases.blockHelperMissing = "helpers.blockHelperMissing"
          @source.push "else { " + nextStack + " = blockHelperMissing.call(" + helperMissingString + "); }"

    populateParams: (paramSize, helperId, program, inverse, hasHash, fn) ->
      needsRegister = hasHash or @options.stringParams or inverse or @options.data
      id = @popStack()
      nextStack = undefined
      params = []
      param = undefined
      stringParam = undefined
      stringOptions = undefined
      if needsRegister
        @register "tmp1", program
        stringOptions = "tmp1"
      else
        stringOptions = "{ hash: {} }"
      if needsRegister
        hash = (if hasHash then @popStack() else "{}")
        @source.push "tmp1.hash = " + hash + ";"
      @source.push "tmp1.contexts = [];"  if @options.stringParams
      i = 0

      while i < paramSize
        param = @popStack()
        params.push param
        @source.push "tmp1.contexts.push(" + @popStack() + ");"  if @options.stringParams
        i++
      if inverse
        @source.push "tmp1.fn = tmp1;"
        @source.push "tmp1.inverse = " + inverse + ";"
      @source.push "tmp1.data = data;"  if @options.data
      params.push stringOptions
      @populateCall params, id, helperId or id, fn, program isnt "{}"

    populateCall: (params, id, helperId, fn, program) ->
      paramString = [ "depth0" ].concat(params).join(", ")
      helperMissingString = [ "depth0" ].concat(helperId).concat(params).join(", ")
      nextStack = @nextStack()
      if @usingKnownHelper
        @source.push nextStack + " = " + id + ".call(" + paramString + ");"
      else
        @context.aliases.functionType = "\"function\""
        condition = (if program then "foundHelper && " else "")
        @source.push "if(" + condition + "typeof " + id + " === functionType) { " + nextStack + " = " + id + ".call(" + paramString + "); }"
      fn.call this, nextStack, helperMissingString, id
      @usingKnownHelper = false

    invokePartial: (context) ->
      params = [ @nameLookup("partials", context, "partial"), "'" + context + "'", @popStack(), "helpers", "partials" ]
      params.push "data"  if @options.data
      @pushStack "self.invokePartial(" + params.join(", ") + ");"

    assignToHash: (key) ->
      value = @popStack()
      hash = @topStack()
      @source.push hash + "['" + key + "'] = " + value + ";"

    compiler: JavaScriptCompiler
    compileChildren: (environment, options) ->
      children = environment.children
      child = undefined
      compiler = undefined
      i = 0
      l = children.length

      while i < l
        child = children[i]
        compiler = new @compiler()
        @context.programs.push ""
        index = @context.programs.length
        child.index = index
        child.name = "program" + index
        @context.programs[index] = compiler.compile(child, options, @context)
        i++

    programExpression: (guid) ->
      return "self.noop"  unless guid?
      child = @environment.children[guid]
      depths = child.depths.list
      programParams = [ child.index, child.name, "data" ]
      i = 0
      l = depths.length

      while i < l
        depth = depths[i]
        if depth is 1
          programParams.push "depth0"
        else
          programParams.push "depth" + (depth - 1)
        i++
      if depths.length is 0
        "self.program(" + programParams.join(", ") + ")"
      else
        programParams.shift()
        "self.programWithDepth(" + programParams.join(", ") + ")"

    register: (name, val) ->
      @useRegister name
      @source.push name + " = " + val + ";"

    useRegister: (name) ->
      unless @context.registers[name]
        @context.registers[name] = true
        @context.registers.list.push name

    pushStack: (item) ->
      @source.push @nextStack() + " = " + item + ";"
      "stack" + @stackSlot

    nextStack: ->
      @stackSlot++
      @stackVars.push "stack" + @stackSlot  if @stackSlot > @stackVars.length
      "stack" + @stackSlot

    popStack: ->
      "stack" + @stackSlot--

    topStack: ->
      "stack" + @stackSlot

    quotedString: (str) ->
      "\"" + str.replace(/\\/g, "\\\\").replace(/"/g, "\\\"").replace(/\n/g, "\\n").replace(/\r/g, "\\r") + "\""

  reservedWords = ("break else new var" + " case finally return void" + " catch for switch while" + " continue function this with" + " default if throw" + " delete in try" + " do instanceof typeof" + " abstract enum int short" + " boolean export interface static" + " byte extends long super" + " char final native synchronized" + " class float package throws" + " const goto private transient" + " debugger implements protected volatile" + " double import public let yield").split(" ")
  compilerWords = JavaScriptCompiler.RESERVED_WORDS = {}
  i = 0
  l = reservedWords.length

  while i < l
    compilerWords[reservedWords[i]] = true
    i++
  JavaScriptCompiler.isValidJavaScriptVariableName = (name) ->
    return true  if not JavaScriptCompiler.RESERVED_WORDS[name] and /^[a-zA-Z_$][0-9a-zA-Z_$]+$/.test(name)
    false
) Handlebars.Compiler, Handlebars.JavaScriptCompiler
Handlebars.precompile = (string, options) ->
  options = options or {}
  ast = Handlebars.parse(string)
  environment = new Handlebars.Compiler().compile(ast, options)
  new Handlebars.JavaScriptCompiler().compile environment, options

Handlebars.compile = (string, options) ->
  compile = ->
    ast = Handlebars.parse(string)
    environment = new Handlebars.Compiler().compile(ast, options)
    templateSpec = new Handlebars.JavaScriptCompiler().compile(environment, options, `undefined`, true)
    Handlebars.template templateSpec
  options = options or {}
  compiled = undefined
  (context, options) ->
    compiled = compile()  unless compiled
    compiled.call this, context, options

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