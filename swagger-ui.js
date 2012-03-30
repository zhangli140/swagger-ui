(function() {
  var SwaggerApi, SwaggerOperation, SwaggerRequest, SwaggerResource, SwaggerUi, functionType, toString,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  SwaggerApi = (function() {

    SwaggerApi.prototype.discoveryUrl = "http://api.wordnik.com/v4/resources.json";

    SwaggerApi.prototype.debug = false;

    SwaggerApi.prototype.api_key = null;

    SwaggerApi.prototype.basePath = null;

    function SwaggerApi(options) {
      if (options == null) options = {};
      if (options.discoveryUrl != null) this.discoveryUrl = options.discoveryUrl;
      if (options.debug != null) this.debug = options.debug;
      if (options.apiKey != null) this.api_key = options.apiKey;
      if (options.api_key != null) this.api_key = options.api_key;
      if (options.verbose != null) this.verbose = options.verbose;
      if (options.success != null) this.success = options.success;
      if (options.success != null) this.build();
    }

    SwaggerApi.prototype.build = function() {
      var _this = this;
      return $.getJSON(this.discoveryUrl, function(response) {
        var res, resource, _i, _len, _ref;
        _this.basePath = response.basePath;
        _this.basePath = _this.basePath.replace(/\/$/, '');
        _this.resources = {};
        _ref = response.apis;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          resource = _ref[_i];
          if (resource.path === "/tracking.{format}" || resource.path === "/partner.{format}") {
            continue;
          }
          res = new SwaggerResource(resource.path, resource.description, _this);
          _this.resources[res.name] = res;
        }
        return _this;
      });
    };

    SwaggerApi.prototype.selfReflect = function() {
      var resource, resource_name, _ref;
      if (this.resources == null) return false;
      _ref = this.resources;
      for (resource_name in _ref) {
        resource = _ref[resource_name];
        if (resource.ready == null) return false;
      }
      this.ready = true;
      if (this.success != null) return this.success();
    };

    return SwaggerApi;

  })();

  SwaggerResource = (function() {

    function SwaggerResource(path, description, api) {
      var parts,
        _this = this;
      this.path = path;
      this.description = description;
      this.api = api;
      if (this.path == null) throw "SwaggerResources must have a path.";
      this.operations = {};
      this.url = this.api.basePath + this.path.replace('{format}', 'json');
      parts = this.path.split("/");
      this.name = parts[parts.length - 1].replace('.{format}', '');
      $.getJSON(this.url, function(response) {
        var endpoint, o, op, _i, _j, _len, _len2, _ref, _ref2;
        _this.basePath = response.basePath;
        _this.basePath = _this.basePath.replace(/\/$/, '');
        if (response.apis) {
          _ref = response.apis;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            endpoint = _ref[_i];
            if (endpoint.operations) {
              _ref2 = endpoint.operations;
              for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
                o = _ref2[_j];
                op = new SwaggerOperation(o.nickname, endpoint.path, o.httpMethod, o.parameters, o.summary, _this);
                _this.operations[op.nickname] = op;
              }
            }
          }
        }
        _this.api[_this.name] = _this;
        _this.ready = true;
        return _this.api.selfReflect();
      });
    }

    return SwaggerResource;

  })();

  SwaggerOperation = (function() {

    function SwaggerOperation(nickname, path, httpMethod, parameters, summary, resource) {
      var _this = this;
      this.nickname = nickname;
      this.path = path;
      this.httpMethod = httpMethod;
      this.parameters = parameters;
      this.summary = summary;
      this.resource = resource;
      this["do"] = __bind(this["do"], this);
      if (this.nickname == null) throw "SwaggerOperations must have a nickname.";
      if (this.path == null) {
        throw "SwaggerOperation " + nickname + " is missing path.";
      }
      if (this.httpMethod == null) {
        throw "SwaggerOperation " + nickname + " is missing httpMethod.";
      }
      this.path = this.path.replace('{format}', 'json');
      this.resource[this.nickname] = function(args, callback, error) {
        return _this["do"](args, callback, error);
      };
    }

    SwaggerOperation.prototype["do"] = function(args, callback, error) {
      var body, headers;
      if (args == null) args = {};
      if (error == null) {
        error = function(xhr, textStatus, error) {
          return console.log(xhr, textStatus, error);
        };
      }
      if (callback == null) {
        callback = function(data) {
          return console.log(data);
        };
      }
      if (args.headers != null) {
        headers = args.headers;
        delete args.headers;
      }
      if (args.body != null) {
        body = args.body;
        delete args.body;
      }
      return new SwaggerRequest(this.httpMethod, this.urlify(args), headers, body, callback, error, this);
    };

    SwaggerOperation.prototype.urlify = function(args) {
      var param, url, _i, _len, _ref;
      url = this.resource.basePath + this.path;
      url = url.replace('{format}', 'json');
      _ref = this.parameters;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        param = _ref[_i];
        if (param.paramType === 'path') {
          if (args[param.name]) {
            url = url.replace("{" + param.name + "}", args[param.name]);
            delete args[param.name];
          } else {
            throw "" + param.name + " is a required path param.";
          }
        }
      }
      if (this.resource.api.api_key != null) {
        args['api_key'] = this.resource.api.api_key;
      }
      url += "?" + $.param(args);
      return url;
    };

    return SwaggerOperation;

  })();

  SwaggerRequest = (function() {

    function SwaggerRequest(type, url, headers, body, callback, error, operation) {
      var obj,
        _this = this;
      this.type = type;
      this.url = url;
      this.headers = headers;
      this.body = body;
      this.callback = callback;
      this.error = error;
      this.operation = operation;
      if (this.type == null) {
        throw "SwaggerRequest type is required (get/post/put/delete).";
      }
      if (this.url == null) throw "SwaggerRequest url is required.";
      if (this.callback == null) throw "SwaggerRequest callback is required.";
      if (this.error == null) throw "SwaggerRequest error callback is required.";
      if (this.operation == null) throw "SwaggerRequest operation is required.";
      if (this.operation.resource.api.verbose) console.log(this.asCurl());
      this.headers || (this.headers = {});
      if (this.operation.resource.api.api_key != null) {
        this.headers.api_key = this.operation.resource.api.api_key;
      }
      if (this.headers.mock == null) {
        obj = {
          type: this.type,
          url: this.url,
          data: JSON.stringify(this.body),
          dataType: 'json',
          error: function(xhr, textStatus, error) {
            return this.error(xhr, textStatus, error);
          },
          success: function(data) {
            return _this.callback(data);
          }
        };
        if (obj.type.toLowerCase() === "post" || obj.type.toLowerCase() === "put") {
          obj.contentType = "application/json";
        }
        $.ajax(obj);
      }
    }

    SwaggerRequest.prototype.asCurl = function() {
      var header_args, k, v;
      header_args = (function() {
        var _ref, _results;
        _ref = this.headers;
        _results = [];
        for (k in _ref) {
          v = _ref[k];
          _results.push("--header \"" + k + ": " + v + "\"");
        }
        return _results;
      }).call(this);
      return "curl " + (header_args.join(" ")) + " " + this.url;
    };

    return SwaggerRequest;

  })();

  window.SwaggerApi = SwaggerApi;

  window.SwaggerResource = SwaggerResource;

  window.SwaggerOperation = SwaggerOperation;

  window.SwaggerRequest = SwaggerRequest;

  window.Handlebars = {};

  Handlebars.VERSION = "1.0.beta.6";

  Handlebars.helpers = {};

  Handlebars.partials = {};

  Handlebars.registerHelper = function(name, fn, inverse) {
    if (inverse) fn.not = inverse;
    return this.helpers[name] = fn;
  };

  Handlebars.registerPartial = function(name, str) {
    return this.partials[name] = str;
  };

  Handlebars.registerHelper("helperMissing", function(arg) {
    if (arguments.length === 2) {
      return undefined;
    } else {
      throw new Error("Could not find property '" + arg + "'");
    }
  });

  toString = Object.prototype.toString;

  functionType = "[object Function]";

  Handlebars.registerHelper("blockHelperMissing", function(context, options) {
    var fn, i, inverse, j, ret, type;
    inverse = options.inverse || function() {};
    fn = options.fn;
    ret = "";
    type = toString.call(context);
    if (type === functionType) context = context.call(this);
    if (context === true) {
      return fn(this);
    } else if (context === false || !(context != null)) {
      return inverse(this);
    } else if (type === "[object Array]") {
      if (context.length > 0) {
        i = 0;
        j = context.length;
        while (i < j) {
          ret = ret + fn(context[i]);
          i++;
        }
      } else {
        ret = inverse(this);
      }
      return ret;
    } else {
      return fn(context);
    }
  });

  Handlebars.registerHelper("each", function(context, options) {
    var fn, i, inverse, j, ret;
    fn = options.fn;
    inverse = options.inverse;
    ret = "";
    if (context && context.length > 0) {
      i = 0;
      j = context.length;
      while (i < j) {
        ret = ret + fn(context[i]);
        i++;
      }
    } else {
      ret = inverse(this);
    }
    return ret;
  });

  Handlebars.registerHelper("if", function(context, options) {
    var type;
    type = toString.call(context);
    if (type === functionType) context = context.call(this);
    if (!context || Handlebars.Utils.isEmpty(context)) {
      return options.inverse(this);
    } else {
      return options.fn(this);
    }
  });

  Handlebars.registerHelper("unless", function(context, options) {
    var fn, inverse;
    fn = options.fn;
    inverse = options.inverse;
    options.fn = inverse;
    options.inverse = fn;
    return Handlebars.helpers["if"].call(this, context, options);
  });

  Handlebars.registerHelper("with", function(context, options) {
    return options.fn(context);
  });

  Handlebars.registerHelper("log", function(context) {
    return Handlebars.log(context);
  });

  Handlebars.Exception = function(message) {
    var p, tmp;
    tmp = Error.prototype.constructor.apply(this, arguments);
    for (p in tmp) {
      if (tmp.hasOwnProperty(p)) this[p] = tmp[p];
    }
    return this.message = tmp.message;
  };

  Handlebars.Exception.prototype = new Error;

  Handlebars.SafeString = function(string) {
    return this.string = string;
  };

  Handlebars.SafeString.prototype.toString = function() {
    return this.string.toString();
  };

  (function() {
    var badChars, escape, escapeChar, possible;
    escape = {
      "<": "&lt;",
      ">": "&gt;",
      "\"": "&quot;",
      "'": "&#x27;",
      "`": "&#x60;"
    };
    badChars = /&(?!\w+;)|[<>"'`]/g;
    possible = /[&<>"'`]/;
    escapeChar = function(chr) {
      return escape[chr] || "&amp;";
    };
    return Handlebars.Utils = {
      escapeExpression: function(string) {
        if (string instanceof Handlebars.SafeString) {
          return string.toString();
        } else {
          if (!(string != null) || string === false) return "";
        }
        if (!possible.test(string)) return string;
        return string.replace(badChars, escapeChar);
      },
      isEmpty: function(value) {
        if (typeof value === "undefined") {
          return true;
        } else if (value === null) {
          return true;
        } else if (value === false) {
          return true;
        } else if (Object.prototype.toString.call(value) === "[object Array]" && value.length === 0) {
          return true;
        } else {
          return false;
        }
      }
    };
  })();

  Handlebars.VM = {
    template: function(templateSpec) {
      var container;
      container = {
        escapeExpression: Handlebars.Utils.escapeExpression,
        invokePartial: Handlebars.VM.invokePartial,
        programs: [],
        program: function(i, fn, data) {
          var programWrapper;
          programWrapper = this.programs[i];
          if (data) {
            return Handlebars.VM.program(fn, data);
          } else if (programWrapper) {
            return programWrapper;
          } else {
            programWrapper = this.programs[i] = Handlebars.VM.program(fn);
            return programWrapper;
          }
        },
        programWithDepth: Handlebars.VM.programWithDepth,
        noop: Handlebars.VM.noop
      };
      return function(context, options) {
        options = options || {};
        return templateSpec.call(container, Handlebars, context, options.helpers, options.partials, options.data);
      };
    },
    programWithDepth: function(fn, data, $depth) {
      var args;
      args = Array.prototype.slice.call(arguments, 2);
      return function(context, options) {
        options = options || {};
        return fn.apply(this, [context, options.data || data].concat(args));
      };
    },
    program: function(fn, data) {
      return function(context, options) {
        options = options || {};
        return fn(context, options.data || data);
      };
    },
    noop: function() {
      return "";
    },
    invokePartial: function(partial, name, context, helpers, partials, data) {
      var options;
      options = {
        helpers: helpers,
        partials: partials,
        data: data
      };
      if (partial === undefined) {
        throw new Handlebars.Exception("The partial " + name + " could not be found");
      } else if (partial instanceof Function) {
        return partial(context, options);
      } else if (!Handlebars.compile) {
        throw new Handlebars.Exception("The partial " + name + " could not be compiled when running in runtime-only mode");
      } else {
        partials[name] = Handlebars.compile(partial);
        return partials[name](context, options);
      }
    }
  };

  Handlebars.template = Handlebars.VM.template;

  window.SwaggerTemplate = "<h1>{{basePath}}</h1><ul class='resources'>  {{#each resource}}  <li class='resource'>    <h2>{{name}}</h2>    <ul class='operations'>      {{#each operation}}      <li class='operation {{httpMethod}}'>        <header>          <h3>            <a class='{{nickname}}'>{{nickname}}</a>          </h3>          <ul class='options'>            <li>              {{summary}}              <li></li>            </li>          </ul>        </header>        <form>          <span class='nickname'>{{nickname}}</span>          <span class='path'>{{path}}</span>          <table>            <thead>              <tr>                <td>Parameter</td>                <td>Value</td>                <td>Description</td>              </tr>            </thead>            <tbody>              {{#each parameter}}              <tr>                <td>{{name}}</td>                <td>{{value}}</td>                <td>{{value}}</td>              </tr>              {{each}}            </tbody>          </table>        </form>        <div class='response'></div>      </li>      {{each}}    </ul>  </li>  {{/each}}</ul>";

  SwaggerUi = (function() {

    SwaggerUi.prototype.dom_id = "swagger-ui";

    function SwaggerUi(options) {
      if (options == null) options = {};
      if (options.dom_id != null) {
        this.dom_id = options.dom_id;
        delete options.dom_id;
      }
      options.success = this.render;
      this.api = new SwaggerApi(options);
    }

    SwaggerUi.prototype.render = function() {
      return console.log("render ui");
    };

    return SwaggerUi;

  })();

  window.SwaggerUi = SwaggerUi;

}).call(this);
