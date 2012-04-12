// lib/handlebars/base.js
var Handlebars = {};

Handlebars.VERSION = "1.0.beta.6";

Handlebars.helpers  = {};
Handlebars.partials = {};

Handlebars.registerHelper = function(name, fn, inverse) {
  if(inverse) { fn.not = inverse; }
  this.helpers[name] = fn;
};

Handlebars.registerPartial = function(name, str) {
  this.partials[name] = str;
};

Handlebars.registerHelper('helperMissing', function(arg) {
  if(arguments.length === 2) {
    return undefined;
  } else {
    throw new Error("Could not find property '" + arg + "'");
  }
});

var toString = Object.prototype.toString, functionType = "[object Function]";

Handlebars.registerHelper('blockHelperMissing', function(context, options) {
  var inverse = options.inverse || function() {}, fn = options.fn;


  var ret = "";
  var type = toString.call(context);

  if(type === functionType) { context = context.call(this); }

  if(context === true) {
    return fn(this);
  } else if(context === false || context == null) {
    return inverse(this);
  } else if(type === "[object Array]") {
    if(context.length > 0) {
      for(var i=0, j=context.length; i<j; i++) {
        ret = ret + fn(context[i]);
      }
    } else {
      ret = inverse(this);
    }
    return ret;
  } else {
    return fn(context);
  }
});

Handlebars.registerHelper('each', function(context, options) {
  var fn = options.fn, inverse = options.inverse;
  var ret = "";

  if(context && context.length > 0) {
    for(var i=0, j=context.length; i<j; i++) {
      ret = ret + fn(context[i]);
    }
  } else {
    ret = inverse(this);
  }
  return ret;
});

Handlebars.registerHelper('if', function(context, options) {
  var type = toString.call(context);
  if(type === functionType) { context = context.call(this); }

  if(!context || Handlebars.Utils.isEmpty(context)) {
    return options.inverse(this);
  } else {
    return options.fn(this);
  }
});

Handlebars.registerHelper('unless', function(context, options) {
  var fn = options.fn, inverse = options.inverse;
  options.fn = inverse;
  options.inverse = fn;

  return Handlebars.helpers['if'].call(this, context, options);
});

Handlebars.registerHelper('with', function(context, options) {
  return options.fn(context);
});

Handlebars.registerHelper('log', function(context) {
  Handlebars.log(context);
});
;
// lib/handlebars/utils.js
Handlebars.Exception = function(message) {
  var tmp = Error.prototype.constructor.apply(this, arguments);

  for (var p in tmp) {
    if (tmp.hasOwnProperty(p)) { this[p] = tmp[p]; }
  }

  this.message = tmp.message;
};
Handlebars.Exception.prototype = new Error;

// Build out our basic SafeString type
Handlebars.SafeString = function(string) {
  this.string = string;
};
Handlebars.SafeString.prototype.toString = function() {
  return this.string.toString();
};

(function() {
  var escape = {
    "<": "&lt;",
    ">": "&gt;",
    '"': "&quot;",
    "'": "&#x27;",
    "`": "&#x60;"
  };

  var badChars = /&(?!\w+;)|[<>"'`]/g;
  var possible = /[&<>"'`]/;

  var escapeChar = function(chr) {
    return escape[chr] || "&amp;";
  };

  Handlebars.Utils = {
    escapeExpression: function(string) {
      // don't escape SafeStrings, since they're already safe
      if (string instanceof Handlebars.SafeString) {
        return string.toString();
      } else if (string == null || string === false) {
        return "";
      }

      if(!possible.test(string)) { return string; }
      return string.replace(badChars, escapeChar);
    },

    isEmpty: function(value) {
      if (typeof value === "undefined") {
        return true;
      } else if (value === null) {
        return true;
      } else if (value === false) {
        return true;
      } else if(Object.prototype.toString.call(value) === "[object Array]" && value.length === 0) {
        return true;
      } else {
        return false;
      }
    }
  };
})();;
// lib/handlebars/runtime.js
Handlebars.VM = {
  template: function(templateSpec) {
    // Just add water
    var container = {
      escapeExpression: Handlebars.Utils.escapeExpression,
      invokePartial: Handlebars.VM.invokePartial,
      programs: [],
      program: function(i, fn, data) {
        var programWrapper = this.programs[i];
        if(data) {
          return Handlebars.VM.program(fn, data);
        } else if(programWrapper) {
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
    var args = Array.prototype.slice.call(arguments, 2);

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
  noop: function() { return ""; },
  invokePartial: function(partial, name, context, helpers, partials, data) {
    options = { helpers: helpers, partials: partials, data: data };

    if(partial === undefined) {
      throw new Handlebars.Exception("The partial " + name + " could not be found");
    } else if(partial instanceof Function) {
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
;
(function() {
  var SwaggerUi,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  SwaggerUi = (function() {

    SwaggerUi.prototype.dom_id = "swagger_ui";

    function SwaggerUi(options) {
      if (options == null) options = {};
      this.render = __bind(this.render, this);
      if (options.dom_id != null) {
        this.dom_id = options.dom_id;
        delete options.dom_id;
      }
      options.success = this.render;
      this.api = new SwaggerApi(options);
    }

    SwaggerUi.prototype.render = function() {
      if (!($("#" + this.dom_id).length > 0)) {
        $('body').append("<div id='" + this.dom_id + "'></div>");
      }
      this.ready = true;
      return this;
    };

    return SwaggerUi;

  })();

  window.SwaggerUi = SwaggerUi;

}).call(this);
(function() {
  var SwaggerApi, SwaggerOperation, SwaggerRequest, SwaggerResource,
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
        if (_this.basePath.match(/^HTTP/i) == null) {
          throw "discoveryUrl basePath must be a URL.";
        }
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

    SwaggerApi.prototype.help = function() {
      var operation, operation_name, parameter, resource, resource_name, _i, _len, _ref, _ref2, _ref3;
      _ref = this.resources;
      for (resource_name in _ref) {
        resource = _ref[resource_name];
        console.log(resource_name);
        _ref2 = resource.operations;
        for (operation_name in _ref2) {
          operation = _ref2[operation_name];
          console.log("  " + operation.nickname);
          _ref3 = operation.parameters;
          for (_i = 0, _len = _ref3.length; _i < _len; _i++) {
            parameter = _ref3[_i];
            console.log("    " + parameter.name + (parameter.required ? ' (required)' : '') + " - " + parameter.description);
          }
        }
      }
      return this;
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

    SwaggerResource.prototype.help = function() {
      var operation, operation_name, parameter, _i, _len, _ref, _ref2;
      _ref = this.operations;
      for (operation_name in _ref) {
        operation = _ref[operation_name];
        console.log("  " + operation.nickname);
        _ref2 = operation.parameters;
        for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
          parameter = _ref2[_i];
          console.log("    " + parameter.name + (parameter.required ? ' (required)' : '') + " - " + parameter.description);
        }
      }
      return this;
    };

    return SwaggerResource;

  })();

  SwaggerOperation = (function() {

    function SwaggerOperation(nickname, path, httpMethod, parameters, summary, resource) {
      var _this = this;
      this.nickname = nickname;
      this.path = path;
      this.httpMethod = httpMethod;
      this.parameters = parameters != null ? parameters : [];
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
      if ((typeof args) === "function") {
        error = callback;
        callback = args;
        args = {};
      }
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

    SwaggerOperation.prototype.help = function() {
      var parameter, _i, _len, _ref;
      _ref = this.parameters;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        parameter = _ref[_i];
        console.log("    " + parameter.name + (parameter.required ? ' (required)' : '') + " - " + parameter.description);
      }
      return this;
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

}).call(this);
(function() {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
templates['template.html'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var buffer = "", stack1, stack2, foundHelper, tmp1, self=this, functionType="function", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  var buffer = "", stack1, stack2;
  buffer += "\n  <li class='resource'>\n    <h2>";
  foundHelper = helpers.name;
  stack1 = foundHelper || depth0.name;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "name", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</h2>\n    <ul class='operations'>\n      ";
  foundHelper = helpers.operation;
  stack1 = foundHelper || depth0.operation;
  stack2 = helpers.each;
  tmp1 = self.program(2, program2, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.noop;
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </ul>\n  </li>\n  ";
  return buffer;}
function program2(depth0,data) {
  
  var buffer = "", stack1, stack2;
  buffer += "\n      <li class='operation ";
  foundHelper = helpers.httpMethod;
  stack1 = foundHelper || depth0.httpMethod;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "httpMethod", { hash: {} }); }
  buffer += escapeExpression(stack1) + "'>\n        <header>\n          <h3>\n            <a class='";
  foundHelper = helpers.nickname;
  stack1 = foundHelper || depth0.nickname;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "nickname", { hash: {} }); }
  buffer += escapeExpression(stack1) + "'>";
  foundHelper = helpers.nickname;
  stack1 = foundHelper || depth0.nickname;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "nickname", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</a>\n          </h3>\n          <ul class='options'>\n            <li>\n              ";
  foundHelper = helpers.summary;
  stack1 = foundHelper || depth0.summary;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "summary", { hash: {} }); }
  buffer += escapeExpression(stack1) + "\n              <li></li>\n            </li>\n          </ul>\n        </header>\n        <form>\n          <span class='nickname'>";
  foundHelper = helpers.nickname;
  stack1 = foundHelper || depth0.nickname;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "nickname", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</span>\n          <span class='path'>";
  foundHelper = helpers.path;
  stack1 = foundHelper || depth0.path;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "path", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</span>\n          <table>\n            <thead>\n              <tr>\n                <td>Parameter</td>\n                <td>Value</td>\n                <td>Description</td>\n              </tr>\n            </thead>\n            <tbody>\n              ";
  foundHelper = helpers.parameter;
  stack1 = foundHelper || depth0.parameter;
  stack2 = helpers.each;
  tmp1 = self.program(3, program3, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.noop;
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </tbody>\n          </table>\n        </form>\n        <div class='response'></div>\n      </li>\n      ";
  return buffer;}
function program3(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n              <tr>\n                <td>";
  foundHelper = helpers.name;
  stack1 = foundHelper || depth0.name;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "name", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</td>\n                <td>";
  foundHelper = helpers.value;
  stack1 = foundHelper || depth0.value;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "value", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</td>\n                <td>";
  foundHelper = helpers.value;
  stack1 = foundHelper || depth0.value;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "value", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</td>\n              </tr>\n              ";
  return buffer;}

  buffer += "<h1>";
  foundHelper = helpers.basePath;
  stack1 = foundHelper || depth0.basePath;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "basePath", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</h1>\n<ul class='resources'>\n  ";
  foundHelper = helpers.resource;
  stack1 = foundHelper || depth0.resource;
  stack2 = helpers.each;
  tmp1 = self.program(1, program1, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.noop;
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</ul>";
  return buffer;});
})();